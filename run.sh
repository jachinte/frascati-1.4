#!/bin/bash

cat << EOB

  *************************************************
  *                                               *
  *    Docker image: jachinte/frascati-1.4        *
  *                                               *
  *************************************************

  CONTAINER SETTINGS
  ------------------
  · FTP & SSH user: frascati
  · FTP & SSH password: frascati
  · Java 1.0.0_23
  · FraSCAti 1.4

EOB

# Start SSH & FTP
service ssh start && service vsftpd start
