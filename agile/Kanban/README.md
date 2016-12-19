# KANBAN

In this section, we will address some good practices related to KANBAN.

## Index
* [KANBAN definition](#definition-of-kanban)
* [Core Properties](#core-properties)
* [KANBAN Board](#kanban-board)
* [Iterations](#iterations)
* [Planning](#planning)
* [Optimization and improvement](#optimization-and-improvement)
* [Good practices for KANBAN teams](#good-habits-for-kanban-teams)
* [References](#references)

### KANBAN definition

Wikipedia's definition for KANBAN is:
> KANBAN is a method for managing knowledge work with an emphasis on just-in-time delivery while not overloading the team members. In this approach, the process, from definition of a task to its delivery to the customer, is displayed for participants to see. Team members pull work from a queue.

> KANBAN in the context of software development can mean a visual process-management system that tells what to produce, when to produce it, and how much to produce - inspired by the Toyota Production System and by Lean manufacturing.

The KANBAN word is a japanese word that means 'card'. Toyota's Production System is based on cards used for production system control. Those cards contain all information needed to make the required pieces at a given time.

![alt text](./static/kanbantoyota.jpg "Toyota Kanban Card")

### Core Properties

There are four Core Properties on KANBAN Method:

 1. **Visualize the work**: Getting all work visible allows a better management and identification of queues and bottlenecks (or personal procrastination on specific tasks).
 2. **Limit Work In Progress (WIP)**: Increase focus and set priorities, manage overload (keeping an adequate margin). A proper load of Work In Progress will keep the team in the flow instead of facing anxiety or boredom.
 3. **Measure and optimize the workflow**: Try to constantly analyze the flow to increase productivity and improve the flow's smoothness.
 4. **Make the policies visible and explicit**: Every team member must know the defined policies for the process.

### KANBAN Board

The KANBAN board is the main tool for following the Core Properties of KANBAN. It reflects the status for a task or story's workflow, from the moment of its creation until it is completed and delivered. 

A KANBAN board can be a physical board or a collaborative digital board. But in any of them, the good practices to follow are the same:
* **Keep the KANBAN board updated**: The board must represent the actual state of the work.
* **Keep the acquired policies visible**: The board is good place to show everyone what the committed policies are.
* **Keep the WIP limit visible**: Each column should reflect its WIP limit.
* **Begin with a simple board**: At first project's stages it is recommended to use a board as simple as possible. For example:

> | To Do | In Process | Done |
> |:-----:|:----------:|:----:|
> |       |            |      | |

Once you know your workflow better, you can add new columns representing a more accurate workflow. For example:

> | To Do | Plan | Develop | Test | Deploy | Done|
> |:-----:|:----:|:-------:|:----:|:------:|:---:|
> |       |      | In progress / Done | | | | |

* **Bottlenecks**: The board can also be useful to detect bottlenecks: when a task cannot advance in the workflow, a potential bottleneck can be the reason. In that case, it is important to find improvements for the workflow that could clear the bottlenecks.

* **Ready Indicators**: In addition to the visual workflow you can use Indicators to visualize when a task can change to the next state on the workflow.

* **Blocked Indicators**: These indicators can help to visualize blocked tasks, than can not be completed or advance through the workflow.

* **Classes of service**: Depending on the tasks' nature, different class of service can be defined. It is completely different to resolve a bug than building a new functionality. Each team must define its own classes of service, but a generic guideline can be followed : 
  * Expedite: Very important task that can not wait to be done.
  * Fixed delivery date: A task that must be delivered at a fixed time.
  * Standard class: A normal task which describes functionality and can be estimated.
  * Intangible class: Tasks that can not be estimated.

* **Policies**: The KANBAN board is a good place to make your policies explicit. You can consider general policies or specific ones for every class of service. 

### Iterations

* In KANBAN **there is no iterations**, as there is only a single iteration, which is continuous. Therefore, backlog is fed as new tasks are needed.
* Finished work increment is planned and completed functionality is released frequently.
* Some iteration's common metrics, like burndown charts, are not available in KANBAN. Instead, there are other ones, like **cycle time**

### Planning

* KANBAN does not include a planning meeting.
* Product's backlog must be ordered by priority and value.
* When a member of the group is idle, he should begin with the next Backlog's item.
* The backlog is continuously fed as new task are needed.
* Tasks' estimation can be performed when the task is placed in the board.

### Optimization and improvement

* KANBAN does not include a retrospective meeting.
* Instead, improvement and optimization is done whenever a team member detects a problem and an opportunity of improving the workflow.

### Good practices for KANBAN teams

* KANBAN is recommended for Cross Teams
* It is strongly recommended that KANBAN teams work as near as possible in order to enhance member communication.
* Although KANBAN does not enforce any roles, it is recommended to have, at least:
  * A business or Product Owner
  * A KANBAN Coach or Agile Coach
* A KANBAN team should strictly focus on the work in progress at any given time
*  The team's goal is to reduce the amount of time an issue takes to move through the entire process

### References
* [Wikipedia](http://tinyurl.com/4nrxsk6)
* [Kanban - David J. Anderson](http://www.amazon.es/dp/0984521402)
* [Agile Coaching - Rachel Davies](http://www.amazon.es/dp/1934356433)
