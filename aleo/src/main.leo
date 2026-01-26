// The 'lending_policy' program 
program lending_policy.aleo {
 // Struct for input data
    struct PolicyInput {
        risk_score: u8,
        collateral_ratio: u64,
    }

    // Struct for output result
    struct PolicyResult {
        approved: bool,
        policy_id: u64,
    }

    // Public mapping to store the last approval result per policy id
    mapping latest_approval: u64 => bool;

    // Transition function for evaluating the lending policy
    async transition evaluate_policy(
        private inp: PolicyInput,
        public policy_id: u64
    ) -> PolicyResult {
        // Simple approval criteria 
        let approved = inp.risk_score > 70 && inp.collateral_ratio >= 150u64;

        // Update mapping with result
        Mapping::set(latest_approval, policy_id, approved);

        // Transition function for evaluating the lending policy
        return PolicyResult { approved, policy_id };
    }
}