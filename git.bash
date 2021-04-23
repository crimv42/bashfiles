branch_del() {
    branch_list=$(git branch | tr -d " *")
    for branch in $branch_list; do 
        if [[ ! "$branch" =~ .*"master".* ]]; then
            ans=""
            while ! [ "$ans" == "n" -o "$ans" == "y" ]
            do
                read -p "Do you want to remove $branch? (y/n)`echo $'\n> '`" yn;
                ans=$(echo $yn | tr '[:upper:]' '[:lower:]')
                if [ "$ans" == "y" ]; then
                    git branch -d $branch
                fi
            done
        fi
    done
}
