This is nginx deployment but with vsock installation in it
Main application docker file viz., nginx docker file is placed on github v2
This v2 has many tools installed in both dockerfiles viz., on remote and on parent. 
In the next version just bareminimum tools will be placed. 
Further, in next version, the 'printf' driven vsock.sh file creation will removed and placed as proper file. 
This is as temporary measure ddone this way in the v2 version as 'enclavectl' was not able to copy any file other than eif and run.sh files

