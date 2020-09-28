#Functions

setBlog(){
    echo "Enter the directory for the blog"
    read blogDir
    if [ -f ~/.configs ]; then
	echo "export blogDir=$blogDir" > ~/.configs
    else
	echo "creating configs file in $HOME"
	echo "export blogDir=$blogDir" > ~/.configs
    fi
    
}

# set blog
blog(){
if [ -z ${blogDir} ]; then
    echo "Blog Dir not set";
    setBlog;
else
    cd $blogDir
fi
}


#Update git repositories
updateRepos(){
    for i in $(ls); do
	pushd $i;
	git pull;
	popd;
    done
}
