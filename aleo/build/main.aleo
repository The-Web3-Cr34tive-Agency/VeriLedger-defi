program lending_policy.aleo;

struct PolicyInput:
    risk_score as u8;
    collateral_ratio as u64;

struct PolicyResult:
    approved as boolean;
    policy_id as u64;

function evaluate_policy:
    input r0 as PolicyInput.private;
    input r1 as u64.public;
    gt r0.risk_score 70u8 into r2;
    gte r0.collateral_ratio 150u64 into r3;
    and r2 r3 into r4;
    cast r4 r1 into r5 as PolicyResult;
    output r5 as PolicyResult.private;
