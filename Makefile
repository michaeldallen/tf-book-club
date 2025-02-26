

DOT_TERRAFORM := /tmp/dot-terraform

TERRAFORM_VERSION := 1.10.5
TERRAGRUNT_VERSION := 0.73.0

make.targets :
	@echo "available Make targets:"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null \
		| awk -v RS= -F: '/^# Implicit Rules/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| fgrep -v '%' \
		| fgrep -v ${HOME} \
		| sed "s/^/    make /" \
		| sort -f -k2,2 -k1,1

env : env.user env.tf

env.user : env.user.bin env.user.tfenv env.user.tgswitch

env.tf : env.tf.install env.tg.install

env.tf.install.list-remote : env.user
	@tfenv list-remote 

env.tf.install.list-remote.latest : env.user
	@tfenv list-remote | fgrep -v -- - | head -1

env.tf.install.latest : env.user
	@tfenv install $$(tfenv list-remote | fgrep -v -- - | head -1)
	@tfenv use $$(tfenv list-remote | fgrep -v -- - | head -1)

env.tf.install env.tf.install.${TERRAFORM_VERSION} : env.user
	@tfenv install ${TERRAFORM_VERSION}
	@tfenv use ${TERRAFORM_VERSION}

env.tf.install.% : env.user
	@tfenv install $*
	@tfenv use $*

env.tg.install : env.user
	@tgswitch ${TERRAGRUNT_VERSION}

env.tg.install.% : env.user
	@tgswitch $*


env.user.bin : ${HOME}/bin

${HOME}/bin :
	mkdir -v $@

env.user.tfenv : env.user.bin ${HOME}/.tfenv 

${HOME}/.tfenv :
	git clone https://github.com/tfutils/tfenv.git ${HOME}/.tfenv
	ln -s ${HOME}/.tfenv/bin/* ~/bin/

env.user.tgswitch : env.user.bin ${HOME}/bin/tgswitch

${HOME}/bin/tgswitch : 
	curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | env BINDIR=$${HOME}/bin bash

tf.dot-terraform.install :
	@[ -d .terraform ] && echo .terraform ok || mkdir -pv .terraform
	@if [ -d .terraform/providers -a ! -L .terraform/providers ] ; then \
		echo "*** warning: using existing local .terraform/providers - you will probably run out of space soon if you are using cloudshell" ; \
	else \
		[ -d ${DOT_TERRAFORM}/providers ] && echo "ok ... ${DOT_TERRAFORM}/providers" || mkdir -pv ${DOT_TERRAFORM}/providers ; \
		[ -L .terraform/providers  -a "$$(readlink -f .terraform/providers)" = "${DOT_TERRAFORM}/providers" ] && echo "ok ... .terraform/providers -> ${DOT_TERRAFORM}/providers" || ln -sv ${DOT_TERRAFORM}/providers .terraform/providers ; \
		fi

tf.dot-terraform.clean : 
	@[ -d ${DOT_TERRAFORM}/providers ] && rm -rfv ${DOT_TERRAFORM}/providers || echo no ${DOT_TERRAFORM}/providers
	@[ -L .terraform/providers ] && rm -fv .terraform/providers || echo no .terraform/providers


tf.init : tf.dot-terraform.install env
	@terraform fmt -check *.tf || echo "you should run 'terraform fmt *tf' so your code is even more beautiful"
	terraform init

tf.init.local : tf.dot-terraform.install env
	[ -d .terraform/modules ] && rm -rfv .terraform/modules || true
	terraform init

tf.init.upgrade : tf.dot-terraform.install env
	terraform init -upgrade

tf.plan : tf.init  env
	terraform plan

tf.plan.local : tf.init.local env
	terraform plan

tf.apply : tf.init env
	terraform apply

tf.apply! : tf.init env
	terraform apply --auto-approve

tf.apply.local : tf.init.local env
	terraform apply

tf.apply.local! : tf.init.local env
	terraform apply --auto-approve

tf.destroy : tf.init env
	terraform destroy

tf.destroy! : tf.init env
	terraform destroy --auto-approve

tf.output : tf.init env
	terraform output

tf.fmt : 
	@terraform fmt -check *.tf > /dev/null && echo ok ... format || terraform fmt -check *.tf | sed 's/$$/ needs formatting/' 

tf.fmt! : 
	@terraform fmt *.tf | sed 's/$$/ formatted/'

tg.init : 
	find . -name terragrunt.hcl | while read tg; do d=$$(dirname $$tg); (cd $$d ; make tf.init); done

tg.run-all.apply :
	terragrunt run-all apply

tg.run-all.destroy :
	terragrunt run-all destroy


tfbc.ch2.test : 
	curl $$(terraform output --raw alb-dns-name):$$(terraform output --raw server-port)

tfbc.ch3.test : 
	echo http://$$(terraform output --raw alb-dns-name):$$(terraform output --raw server-port)

