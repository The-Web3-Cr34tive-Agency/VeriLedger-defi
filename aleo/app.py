import os
import json
import hashlib
from web3 import Web3

def calculate_keccak(data_string):
    # Web3 standard keccak256
    return Web3.keccak(text=data_string).hex()

def get_policy_hash(file_path):
    # This reads your 'main.aleo' file and creates a fingerprint of it.
    # If the logic in main.aleo changes, this hash changes.
    if not os.path.exists(file_path):
        return "0x0000000000000000000000000000000000000000000000000000000000000000"
    
    with open(file_path, 'rb') as f:
        bytes = f.read()
        return Web3.keccak(bytes).hex()

def mock_risk_evaluation(data):
    # 1. Extract Private Data
    amount = data['private_data']['loanAmount']
    collateral = data['private_data']['collateralValue']
    score = data['private_data']['creditScore']

    # 2. The Logic (Mocking your Aleo/Risk logic)
    ltv = amount / collateral
    
    # Simple Rule: Approve if LTV < 0.80 and Score > 700
    is_approved = (ltv < 0.80) and (score > 700)
    
    # Return a structured result
    return {
        "approved": is_approved,
        "risk_score": int(ltv * 100), # e.g., 76
        "timestamp": 1706260000
    }

def main():
    # A. Load the Encrypted Input (iExec handles the decryption path)
    # On iExec, the dataset is usually at /iexec_in/
    input_file_path = os.environ.get('IEXEC_IN', '/iexec_in') + '/sample_input.json'
    
    with open(input_file_path, 'r') as f:
        inputs = json.load(f)

    thread_id = inputs['public_metadata']['threadId']

    # B. Calculate Policy Hash (The "Fingerprint" of your Aleo logic)
    # Assuming main.aleo is bundled in the Docker image at /app/main.aleo
    policy_hash = get_policy_hash("/app/main.aleo")

    # C. Run Risk Logic
    result_data = mock_risk_evaluation(inputs)
    
    # D. Construct the Final Output Hash
    # We concatenate: Result (0/1) + ThreadID + PolicyHash
    # This proves: "This Result" belongs to "This Thread" using "This Logic"
    
    result_bool_str = "1" if result_data['approved'] else "0"
    
    # Concatenation string
    payload = result_bool_str + thread_id + policy_hash
    final_hash = calculate_keccak(payload)

    print(f"Computed Hash: {final_hash}")
    
    # E. Write the result to the filesystem (iExec picks this up)
    # The 'callback' file is what gets sent back to the smart contract
    with open(os.environ.get('IEXEC_OUT', '/iexec_out') + '/computed.json', 'w') as f:
        json.dump({"callback-data": final_hash}, f)

if __name__ == "__main__":
    main()