"""Some code for dealing with StableSwap curves in any number of assets. Most of the symbolic stuff is just using variables. You obv need to substitute the variables to get something useful.

Note that the 2-asset case of StableSwap is special b/c you can solve it reasonably well analytically. We don't implement any special methods here, though.

Technical note: Idk how to do variable-length vectors in Sage (or if it's even possible tbh), so this uses an old-school global init function. Probably there's a better way to do this with classes but whatever.
"""

# a = amplification parameter
# d = invariant
var('a d')

# Overwritten by init.
# n = number of assets
# t = vector of asset amounts
n = 0
t = vector([])
eq_stableswap = None  # Invariant equation


def init_stableswap(n_assets):
    """Call this first."""
    global n, t, eq_stableswap
    n = n_assets
    t = vector(var('t', n=n))
    eq_stableswap = a * n**n * sum(t) + d == a * d * n**n + d**(n+1) / (n**n * product(t))

    
def stableswap_get_d(balances, a):
    """balances, a have to be values, not variables."""
    assert len(balances) == n
    
    eq = eq_stableswap.subs({t[i]: balances[i] for i in range(n)}, a=a)
    d_upper = n * max(balances)  # Could also use sum(balances) I think.
    
    d_sln = find_root(eq, 0, d_upper)
    return d_sln


def test_all():
    """Sanity checks. Tests require a specific n, so we put them into a function."""
    init_stableswap(4)
    assert stableswap_get_d([1,1,1,1], 123) == 4
    