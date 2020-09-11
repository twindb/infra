===============
Service network
===============

.. image:: https://readthedocs.com/projects/revdb-terraform-aws-service-network/badge/?version=latest&token=507e06a963ad2ed4e22309417e62200b674c9b6b1989ad9ed9ce1c844d368e97
    :target: https://revdb-terraform-aws-service-network.readthedocs-hosted.com/en/latest/?badge=latest
    :alt: Documentation Status


Service network is a VPC that hosts one logical unit of services.
It can be one service like MySQL or it can comprise of several services.
For example, a website with HTTP service and MySQL service.

One service network is an island. Instances inside the island
can communicate to each other and outside world.

Two different service networks cannot communicate to each other.
This is not a limitation but security feature.

There is a special kind of service network - management service network.
It is a bridge between other service network.
The management service network can communicate to all other service networks.
The management network is needed to host common services like Chef server, bastion hosts etc.

Usage
=====

The management network.

.. code-block:: terraform

    module "management" {
      source                = "/path/to/module"
      environment           = "dev"
      service_name          = "management"
      vpc_cidr_block        = "10.1.0.0/16"
      management_cidr_block = "10.1.0.0/16"
      subnets = [
        {
          cidr                    = "10.1.0.0/24"
          availability-zone       = "${var.region}a"
          map_public_ip_on_launch = true
          create_nat              = true
          forward_to              = null
        },
        {
          cidr                    = "10.1.1.0/24"
          availability-zone       = "${var.region}b"
          map_public_ip_on_launch = false
          create_nat              = false
          forward_to              = "10.1.0.0/24"
        },
        {
          cidr                    = "10.1.2.0/24"
          availability-zone       = "${var.region}c"
          map_public_ip_on_launch = false
          create_nat              = false
          forward_to              = "10.1.0.0/24"
        }
      ]
    }

Service network (for website or other service).

.. code-block:: terraform

    module "website" {
      source                = "/path/to/module"
      environment           = "dev"
      service_name          = "website"
      vpc_cidr_block        = "10.3.0.0/16"
      management_cidr_block = "10.1.0.0/16"
      subnets = [
        {
          cidr                    = "10.3.0.0/24"
          availability-zone       = "${var.region}a"
          map_public_ip_on_launch = true
          create_nat              = true
          forward_to              = null

        },
        {
          cidr                    = "10.3.1.0/24"
          availability-zone       = "${var.region}b"
          map_public_ip_on_launch = false
          create_nat              = false
          forward_to              = "10.3.0.0/24"
        }
      ]
    }
