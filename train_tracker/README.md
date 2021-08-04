🚂 **The Train Tracker**

Track and manage train schedules


**MY ASSUMPTIONS:**

From the language: 
* ”runs through this station”: we are concerned with THIS station. We are writing a schedule manager for one station for now, and not multiple stations. 
* in creating the capability to post a ”list of times when this particular train arrives at this station”: this provides another confirmation that we are concerned with THIS station and not more than one station. 
* Also we are concerned with LISTS of ARRIVALS. So we are going to take a list of arrival times and save the list to associate with a train line. 
* This may be considered a bit of an extrapolation of the text, but I am going to assume that we are NOT concerned for now with departure times. Only arrivals. 
* “These are specific to the minute the train arrives” - we are going to assume that in reading the data, we want whatever time format we save to easily convert to be legible in this format: ‘9:53 PM’. We may save the data in this exact format, as a string confined to assumed regex-controlled input, or we may save it in some other format, depending on the time I have left when we get to that concern. If this were part of a real app, I would make a point of putting a lot of weight and research on this particular decision, choosing how to store and manage time is a tricky business with consequences that magnify over the life of an app.
* “Post a schedule for a new train line” - for now we assume that we are always posting a schedule for a new train line, and not an existing one. I think I’ll create a data structure that will accommodate new schedules for existing train lines, as that seems like a likely use case, but the post I create will always be adding a new train line and a new schedule. The post will not be concerned with whether the train line OR schedule already exists, and associating the two will depend on ids or uids. Although I would argue that it’s preferable to not repeat train line names, and the best version of this service would provide a simple solution to not repeat the post/creation of new train lines with the same names. 
 

To simplify things: 
* I assume that there is one train per line. The client is not concerned with whether there are multiple trains on a line (if there are, we treat them as one train. We are concerned with whether there is a physical vehicle coming into the station on this line, rather than size/capacity/style/year/model/etc). For this service at this time TRAIN = TRAIN LINE. 
* I assume that the person/user/client to both post and get information from this service is NOT of concern at this time. Perhaps other services are concerned with authorizing and defining those who access and add this data.
* I assume that we want to treat a list of times as immutable data. This is a bigger assumption that includes several smaller assumptions. 
* We don’t want to insert new times to a posted schedule or delete times from a list of times. 
* We may want to stop making use of a posted schedule for understanding the current schedule of a train line, but immutability on posted schedules will make historical data reliable, in that one could look at the posted times for a train line during last minute/day/week/month and they wouldn’t necessarily reflect the current schedule or other past schedules. I think this could be good for tracking data about the station’s performance and maintenance, for legal reasons, and for data storage reasons. In regards to data storage: I think it would help with data accuracy, reliability, and security. Why? By creating a new data row every time you post a new schedule (instead of altering existing rows) you’re putting a tighter grip on how things change in the database. There’s less room for error when you’re only posting fields and not updating them. When you’re saving an entirely new row to a database you’re not locking all the existing rows from getting accessed like you would when you’re updating a row (performance). This will mean that we’re kind of teaching the code/coders to never attempt to perform multiple changes to a schedule at once (something like “add this and delete that”). AND I believe it will mean that we could more easily place controls and character limits on the field that reflects the schedule (the list of times). 
* Within the data structure I propose and the requests we build on this service for this assignment, we assume that the current/relevant/useful schedule for a train line is the most recently added schedule, to be determined by a database timestamp. We probably want to have a train_lines table and a schedules table, and in order to prevent the “GET” from being too costly (we don’t want to have to scan through every schedule we’ve ever stored, or every schedule we’ve ever associated with one train line, OR every train_line and its associated schedules), any time we add a new schedule to the schedules table, we will make updates on a current_schedules table. This table will have columns for an id, a schedule_id, and a train_line id. Ultimately, this table should only ever contain as many rows as there are train lines 
* When we perform the operation of getting “the next time” multiple trains arrive, we assume that the requested “time value as an argument” is looking for the next time on the current_schedule (when there are 2 or more train lines with the same next time, as per “reflects the next time two or more trains will arrive at this station simultaneously”). 


**THINGS TO CONSIDER**

How can we make it so that we do not have to scan through every current schedule? This solution isn’t very performant if we have to compare all the current schedules every time we GET stuff.

Can we group train lines by schedule instead? 
If trains came every 5 minutes, or every 10 minutes, we could much more easily sort and retrieve our data in a performant way. 

With the possibility of trains coming at any suggested minute, when we store a new schedule, we may want to: sort the times chronologically, find the earliest time and the latest time, and store those. That way we have a range we can use to sort schedules before we start comparing them. Given a time, if we are not able to pull two schedules with a range that encompasses it, then we look for two schedules that start at the same earliest time. If we do not have two schedules that start at the same time, then we return no time. If we do find two or more schedules with a range that encompass the time, then we compare the lists to 

**POSSIBLE SOLUTION FOR RETRIEVING SIMULTANEOUS TRAIN ARRIVAL TIMES**

One idea I have for accomplishing the task of getting the "next time" two or more trains arrive would be to use the range idea I proposed just above. By storing a range for each of the *current schedules*, you could:

* Look for schedules that have a range which contain the timestamp argument you recieve. 

* We are looking to return *two* or more trains that arrive at the same time, otherwise we return none. So now that we have all schedules ids, their ranges, and their schedule lists, we look into each lists for all the times that come *just next* after the timestamp argument we recieved. 

* If the number of lists (schedules) that contain a matching "just next" time is two or greater than two, we return those two or more schedules. 

* If we do not find two or more, we now must obtain all the current schedules with a start time earlier than the timestamp argument. 

* From those schedules we will have to look for the earliest matching start time. In order to return two times or none, I think the fastest way to get there would be to sort the schedules by range, chronologically so that the first schedule you'd find in sorted list would be the earliest time. We now look to see if the second schedule in the list matches. If it does, we return those two schedules. If it does not, we continue the loop and look at the next schedule to see if the start time matches. 


**DOMAINS**

*Train_lines* - uid, name (string with four alphanumeric characters)

*Schedule* - we are concerned with the current schedule for now. Past schedules on a line are going to be available in this architecture as well. This is a list. 




## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `train_tracker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:train_tracker, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/train_tracker](https://hexdocs.pm/train_tracker).

