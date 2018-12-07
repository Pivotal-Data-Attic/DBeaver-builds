cd ~/workspace/dbeaver
branchname=$(git branch | grep \* | cut -d ' ' -f2)
commitmessage=$(git log --format=%B -n 1 $branchname)
echo $commitmessage

mvn clean package

#switch or create a branch with branchname
cd ~/workspace/dbeaver-builds
git checkout $(git show-ref --verify --quiet refs/heads/$branchname || echo '-b')$branchname

#copy the built app to the built-app repo
rm -rf DBeaver.app
cp -R ~/workspace/dbeaver/product/standalone/target/products/org.jkiss.dbeaver.core.product/macosx/cocoa/x86_64/DBeaver.app ~/workspace/dbeaver-builds

#create commit with commitmessage
git add .
git commit -m "$commitmessage"

#push commit
git push -u origin $branchname

# Checkout to master because we don't want people branching off branches. 
git checkout master