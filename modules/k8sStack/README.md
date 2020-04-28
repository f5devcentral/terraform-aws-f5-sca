# k8sStack

__Overview__

This module deploys a known vulnerable web application named juicebox in a Fargate Contiainer using AWSVPC network mode.  DO NOT USE IT IN A PRODUCTION ENVIRONMENT.  DO NOT CONNECT THIS VPC TO A PRODUCTION ENVIRONMENT OR ANY ENVIRONMENT WHERE A BREACH WILL CAUSE HARM. F5 MAKES NO WARRANTIES OR SUPPORT FOR THIS APPLICATION OR ANY BREACH, LOSS, OR OTHER EVENT DUE TO USING THIS APPLICATION. IT IS FOR SECURITY TESTING AND EXAMPLE ONLY. 

__Deployment__

The F5 Secuirty Stack with all forwarding compnents MUST be online and able to send traffic outbound from tenant VPCs for this module to complete as egress is required to launch the containers.  Additionally this requriement will force you to place the containers in a virtual server to allow inbound access where you apply a Web Applicaiton Firewall policy. 



