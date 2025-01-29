

DOT-TERRAFORM := /tmp/dot-terraform

all :  dot-terraform.install

clean :  dot-terraform.clean

dot-terraform.install :
	@[ -d ${DOT-TERRAFORM} ] && echo ${DOT-TERRAFORM} ok || mkdir -pv ${DOT-TERRAFORM}
	@[ -L .terraform  -a "$$(readlink -f .terraform)" = "/tmp/dot-terraform" ] && echo .terraform ok || ln -sv ${DOT-TERRAFORM} .terraform

dot-terraform.clean : 
	@[ -d ${DOT-TERRAFORM} ] && rm -rfv ${DOT-TERRAFORM} || echo no ${DOT-TERRAFORM}
	@[ -L .terraform ] && rm -fv .terraform || echo no .terraform
