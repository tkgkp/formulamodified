:!UTF-8
SELECT 0 as LP, M.KTM, M.N
FROM M
WHERE M.reference NOT IN (SELECT ZK_P.M FROM @ZK_P join @ZK_N using (ZK_P.N,ZK_N.reference) WHERE ZK_N.DP > to_date(:_a)) AND
M.KTM like ':_b%'
ORDER BY M.KTM,M.N