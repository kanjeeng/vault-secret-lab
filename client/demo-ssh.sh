#!/bin/bash
# OPSIONAL: contoh login SSH OTP dari client-node.
vault ssh -role otp_key_role -mode otp -strict-host-key-checking=no otpuser@10.3.1.30
