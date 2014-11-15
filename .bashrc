# If we're on OS X
if [ "$(uname)" == "Darwin" ]
then
	source ~/.bashrc_bsd
else
	source ~/.bashrc_lin
fi
