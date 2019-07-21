# Monitoring a kubernetes cluster with a Led Matrix and a RaspberryPi


![Pod scaling to 58 replicas](./assets/pod-scaling.gif)

Recently I have purchased a set of 5 respberry pi boards planning on investing some time in container orchestration. First of all I got it all working fine on Docker with Swarm so I could move to the next level with Kubernetes.

While watching videos and courses on Kubernetes, I still felt that I was in need of a more visual way to see the activity on my cluster. I don't mean the actual activity that can be seen through Istio or other service meshes, but to literally see the Pods scaling up and down across the nodes.

As a big fan of IoT, I had the idea of using leds to represent the current state of my cluster. I'm not a Python guy nor a Shell script developer, but I really wanted to make this happen.

The first prototype was just to make an RGB led blink N times based on the number of pods that were up and running. That was nice, but still not helpful.

I then started looking for a good RGB led matrix and found the [Pimoroni's UnicornHat](https://github.com/pimoroni/unicorn-hat). This board provides an 8x8 led matrix that can be easily controlled via Python.

Okay, now that I had all the pieces, it was time to put it all together. First of all I had to get the list of pods, were they were running and their current state. All that information is available via the ```kubectl get pods -o json``` command. The states and the nodes they are allocated to will also be there. For finding out the possible states, I just used the [kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-phase).

To summarize the data, I used [jq](https://stedolan.github.io/jq/). With that I was able to transform the data and categorize it based on two of the most important statuses for me: pending and running.

The _pending_ status:

>The Pod has been accepted by the Kubernetes system, but one or more of the Container images has not been created. This includes time before being scheduled as well as time spent downloading images over the network, which could take a while.

The _running_ status:

>The Pod has been bound to a node, and all of the Containers have been created. At least one Container is still running, or is in the process of starting or restarting.

As my led board is an 8x8 matrix and my cluster has 1 master and 4 workers, it was just right to use two columns per worker node. This way I could display the presence of up to 16 pods per node.

I then decided to create a code to represent the state of each led and generate a 64 char long string, where each group of 16 represented each node. This would be the ideal way to feed my leds.

Finally I got to the python script that would run an infinite loop and light up each one of the leds based on the status provided by the execution of the previous script. BINGO! Blues for _pending_ and greens for _running_.

The command below starts the watcher in python that updates the led matrix. The arg _"default"_ is in fact the namespace that we want to watch.

```bash
python ./k8s-unicorn-lights.py default &
````

Interestingly enough, after trying it out, I found that the _pending_ state is also used while a pod is being terminated, which is not mentioned in the [Pod phase](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-phase) documentation.

For those that do not have a pi-cluster, it is still possible to use these scripts on a single Pi board (even a pi zero) to watch any remote Kubernetes cluster. Just make sure to review the names for the nodes on line 6 from [k8s-unicorn-lights.sh](./k8s-unicorn-lights.sh) and point your ```kubectl```configuration on your Pi to your remote cluster.