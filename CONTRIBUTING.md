# Contributing

Thank you for helping learners use Terraform safely.

1. Fork the repository and create a focused branch.
2. Make the smallest complete change, including documentation.
3. Run `./scripts/check.sh`; it performs only offline validation and mocked tests.
4. Open a pull request using the template and describe cost and security impact.

Never commit AWS credentials, `.tfstate`, `.tfplan`, `backend.hcl`, real account identifiers, or copied proprietary interview material. Contributions should be original and should teach the reason behind each design choice.
