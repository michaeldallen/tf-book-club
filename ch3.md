state file:
* watch for "./" in s3 bucket
* note `-target` for state file operations/maintenace in a broken system
* like most other aspects of terraform, has the feel of a tool that got labeled a product
* (muda) s3 bucket policy best practice conflicts with SSG aws policy - confusing when "doing the right thing" is blocked byj corporate policy, and corporate policy (silently) enforces "the right thing".
  * `aws_s3_bucket_public_access_block`
* s3 backend management with `terragrunt` handles bucket creating, not cleanup
  * workflow using bucket deleting out of model, shows deviation from "the most-travelled path"
 

## FAYG

hung up on ch2; blocking to fix before doing ch3

* enable using book club to POC a production problem in observability clusters
