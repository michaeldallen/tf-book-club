

DOT_TERRAFORM := /tmp/dot-terraform

TERRAFORM_VERSION := 1.10.5

make.targets :
	@echo "available Make targets:"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null \
		| awk -v RS= -F: '/^# Implicit Rules/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| fgrep -v '%' \
		| fgrep -v ${HOME} \
		| sed "s/^/    make /" \
		| sort -f -k2,2 -k1,1

env : env.user env.tf

env.user : env.user.bin env.user.tfenv

env.tf : env.tf.install

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

env.user.bin : ${HOME}/bin

${HOME}/bin :
	mkdir -v $@

env.user.tfenv : env.user.bin ${HOME}/.tfenv 

${HOME}/.tfenv :
	git clone https://github.com/tfutils/tfenv.git ${HOME}/.tfenv
	ln -s ${HOME}/.tfenv/bin/* ~/bin/

tf.dot-terraform.install :
	@[ -d ${DOT_TERRAFORM} ] && echo "ok ... ${DOT_TERRAFORM}" || mkdir -pv ${DOT_TERRAFORM}
	@[ ! -L .terraform -a -d .terraform ] && { echo local local directory .terraform exists. cannot install .terraform symlink to ${DOT_TERRAFORM} ; exit 1 ; } || echo "ok ... no local .terraform"
	@[ -L .terraform  -a "$$(readlink -f .terraform)" = "${DOT_TERRAFORM}" ] && echo "ok ... .terraform -> ${DOT_TERRAFORM}" || ln -sv ${DOT_TERRAFORM} .terraform

tf.dot-terraform.clean : 
	@[ -d ${DOT_TERRAFORM} ] && rm -rfv ${DOT_TERRAFORM} || echo no ${DOT_TERRAFORM}
	@[ -L .terraform ] && rm -fv .terraform || echo no .terraform


tf.init : tf.dot-terraform.install env
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


tfbc.ch2.test : 
	curl $$(terraform output --raw alb-dns-name):$$(terraform output --raw server-port)


