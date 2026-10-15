"""Reaction-torque step test (15 Oct): fast spin-up 0 -> 600 rpm at 300 rpm/s, no added mass.

During a constant-acceleration ramp the motor's reaction torque on the platform is J*alpha
(bearing friction is internal to the rotor/stator pair, so it is not transmitted). The radial
piezos are AC-coupled, so a torque step shows as a jump that then decays. The model fitted to
the 3 Hz low-passed Mz is A*[h(t-ts) - h(t-ts-Tr)], with h(t) = exp(-t/tau) for t >= 0 and
Tr = 600/300 = 2 s.

Mz = s/2 * (Rx1 - Rx2) with s = 0.105 m (Ry1 is on the spin axis, so it gives no Mz).

Usage: python -I torque_step.py "<path to 15_10_26_tests>"
"""
import sys
import os
import numpy as np

FS = 10000
ALPHA = 300 * 2 * np.pi / 60          # rad/s^2
TR = 600 / 300                        # s, ramp duration
S = 0.105                             # m, Rx1-Rx2 spacing

# Inertia estimate of the rotating parts [kg m^2]:
#   16 M8 bolts (9.56 g) at r = 65 mm
#   PLA wheel 105.97 g: ~77% in the rim (R55-R75 annulus), ~23% in the spokes
#   motor rotor and coupling: ~6e-6
J_EST = (16 * 9.56e-3 * 0.065**2
         + 0.106 * (0.77 * (0.075**2 + 0.055**2) / 2 + 0.23 * 0.055**2 / 3)
         + 6e-6)


def lowpass(x, fc):
    X = np.fft.rfft(x)
    X[np.fft.rfftfreq(len(x), 1 / FS) > fc] = 0
    return np.fft.irfft(X, len(x))


def fit_run(path):
    d = np.genfromtxt(path, delimiter=',', skip_header=1, usecols=(1, 2), invalid_raise=False)
    d = d[np.all(np.isfinite(d), axis=1)]
    t = np.arange(len(d)) / FS
    mz = S / 2 * (d[:, 0] - d[:, 1])
    mz -= mz[:4 * FS].mean()
    r = np.sqrt(np.convolve((d**2).sum(1), np.ones(500) / 500, 'same'))
    t0 = t[np.argmax(r > 5 * np.median(r[:3 * FS]))]       # motor start
    y = lowpass(mz, 3)
    m = (t > t0 - 0.5) & (t < t0 + 6)
    best = None
    for tau in np.arange(0.5, 6.01, 0.1):
        for dts in np.arange(-0.15, 0.151, 0.01):
            ts = t0 + dts
            h = lambda x: np.where(x >= 0, np.exp(-np.clip(x, 0, None) / tau), 0.0)
            hm = lowpass(h(t - ts) - h(t - ts - TR), 3)
            A = np.dot(hm[m], y[m]) / np.dot(hm[m], hm[m])
            res = np.sum((y[m] - A * hm[m])**2)
            if best is None or res < best[0]:
                best = (res, A, tau, dts)
    res, A, tau, dts = best
    r2 = 1 - res / np.sum((y[m] - y[m].mean())**2)
    return A, tau, r2


if __name__ == '__main__':
    folder = sys.argv[1] if len(sys.argv) > 1 else '.'
    print('alpha = %.2f rad/s^2, J estimate %.3e kg m^2 -> J*alpha = %.4f N m' % (ALPHA, J_EST, J_EST * ALPHA))
    amps = []
    for k in (1, 2, 3):
        f = os.path.join(folder, 'TORQUE_600_T%d.csv' % k)
        if not os.path.isfile(f):
            continue
        A, tau, r2 = fit_run(f)
        amps.append(A)
        print('T%d: step %+.4f N m, decay %.1f s, R^2 %.3f, J = %.3e kg m^2' % (k, A, tau, r2, A / ALPHA))
    if amps:
        a = np.array(amps)
        sd = a.std(ddof=1) if len(a) > 1 else float('nan')
        print('mean %.4f N m (sd %.4f) = %.0f%% of J*alpha' % (a.mean(), sd, 100 * a.mean() / (J_EST * ALPHA)))
