## Introduction

# Justification

I'm a firm believer that when learning a new technology that keeping things simple in the first instance is of paramount importance.  Frankly all the frilly bits can come later!

What I offer here is a basic example of deploying an AWS infrastructure using Terraform.  You can use this simple structure to deploy a simple EC2 instance with a VPC and attached Security Group.  With the configuration in this project, you should be able to quickly and easily securely access your Instance from the terminal

Do not expect this to be complete with all industry best practices, however if you are new to working with Terraform then this could be a good sample project to start with! My hope is that you will find some use in 'poking' this implementation to see how it works and changing it to see how it breaks. Below I will explain what some important sections of the code are doing so that you can start to build your own deployments.

## What is going on?

To create the structure of this project I have chosen to split the resources that I am creating into modules, these modules means that my deployment is easier to write, debug and maintain.

You will notice a consistent style within the project, the terraform code that is written for each module is grouped into 3 files, and these 3 .tf files also appear in the root of the project.

### main.tf

In this file the terraform resources are described, unless you are looking in the root of the project structure in which case the main.tf file describes the modules used in the project.

### variables.tf

In this file the variables that are used by the project and the various modules are defined, you will find that most of the variables are defined in the variables.tf file in the root of the project, making working with the project a little easier.

### outputs.tf

Often the least used of the 3 files, here the output from the resources created are defined.  This can be useful if you want to print some output to the console when the deployment is completed, you can also use it to pass the output from one module to be used with another.

## Project Modules

### VPC

Starting with the VPC, this module creates the resources required for setting up a basic VPC. Looking in the main.tf file we first see a data block, this is a special block that returns a list of all the AZ's avaliable with your selected region (in our case eu-west-1).  You dont need to select an AZ like this, however by doing so means that we will also select a valid AZ for our Subnet, without having to do any research.

We next have a **aws_vpc** resource block

Moving onto the **aws_subnet** resource block, you can see that we have made use of the Data block we defined earlier, as well as attaching this subnet to our VPC, and adding a relevant CIDR block.

The next resource block, **aws_internet_gateway** creates the IGW that our VPC will use, remember that you can only have one IGW per VPC.  We have given this IGW a name using Tags so that we can easily refer to it later.

The next 2 resource blocks, **aws_route_table** and **aws_main_route_table_association** will create the route table used by our VPC and attach it.  We have only defined one route in our route table and

### SG

There are 3 blocks in the main.tf file for this module, however only one of them is a resource block.

The data block, sends a GET Request to https://ifconfig.me, I wanted a way to programatically include my IP address into the creation of the SG such that only my IP would be allowed to SSH into the machine.  It is the locals block that takes this output to be used later.

In the resource block for this module we are creating the SG that our VPC needs.  We are creating an Ingress to port 22 for our SSH connection, ensuring that we use our IP address as described in the previous section.

We are also creating an Egress.

### EC2

This module will have the most tangible purpose, however it also relies on the other 2 sections created earlier hence why it has been left to the end.

Firstly we are using a special data block to get the AMI id for the ***AMAZON 2*** image avaliable in our region.  Again we could do this without the data block, however as the AMI id's for the *** AMAZON 2*** are different for each region our code would not be particulary portable.  It's actually also easier then finding the AMI id for the image you want to use, assuming you are using an AWS supplied.

The first resource block registers the key pair that we will use to connect to our instance. You do need to ensure that you already have a key pair created on your system, here I have just used the default values when **ssh-keygen** is used.  This step means we can quickly connect to the EC2 instance once it has been created.

The final resource is the **aws_instance** we are creating.  We use a lot of information that we have discussed and defined elsewhere, sometimes in different modules.

