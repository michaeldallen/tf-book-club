

DOT-TERRAFORM := /tmp/dot-terraform

make.targets :
	@echo "available Make targets:"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null \
		| awk -v RS= -F: '/^# Implicit Rules/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| fgrep -v '%' \
		| sed "s/^/    make /" \
		| sort -f -k2,2 -k1,1

user : user.tf

user.tf : ${HOME}/bin/terraform

${HOME}/bin/terraform : ${HOME}/bin ${HOME}/.tfenv
	@tfenv install $$(tfenv list-remote | fgrep -v -- - | head -1)
	@tfenv use $$(tfenv list-remote | fgrep -v -- - | head -1)

${HOME}/bin : 
	mkdir -v ${HOME}/bin

${HOME}/.tfenv :
	git clone https://github.com/tfutils/tfenv.git ${HOME}/.tfenv
	ln -s ${HOME}/.tfenv/bin/* ~/bin/

tf.dot-terraform.install :
	@[ -d ${DOT-TERRAFORM} ] && echo "ok ... ${DOT-TERRAFORM}" || mkdir -pv ${DOT-TERRAFORM}
	@[ ! -L .terraform -a -d .terraform ] && { echo local local directory .terraform exists. cannot install .terraform symlink to ${DOT-TERRAFORM} ; exit 1 ; } || echo "ok ... no local .terraform"
	@[ -L .terraform  -a "$$(readlink -f .terraform)" = "${DOT-TERRAFORM}" ] && echo "ok ... .terraform -> ${DOT-TERRAFORM}" || ln -sv ${DOT-TERRAFORM} .terraform

tf.dot-terraform.clean : 
	@[ -d ${DOT-TERRAFORM} ] && rm -rfv ${DOT-TERRAFORM} || echo no ${DOT-TERRAFORM}
	@[ -L .terraform ] && rm -fv .terraform || echo no .terraform


tf.init : tf.dot-terraform.install user.tf
	terraform init

tf.init.local : tf.dot-terraform.install
	[ -d .terraform/modules ] && rm -rfv .terraform/modules || true
	terraform init

tf.init.upgrade : tf.dot-terraform.install
	terraform init -upgrade

tf.plan : tf.init
	terraform plan

tf.plan.local : tf.init.local
	terraform plan

tf.apply : tf.init
	terraform apply

tf.apply! : tf.init
	terraform apply --auto-approve

tf.apply.local : tf.init.local
	terraform apply

tf.apply.local! : tf.init.local
	terraform apply --auto-approve

tf.destroy : tf.init
	terraform destroy

tf.destroy! : tf.init
	terraform destroy --auto-approve


tfbc.ch2.test : 
	curl $$(terraform output --raw alb-dns-name):$$(terraform output --raw server-port)


