defmodule TrainTracker do
  @moduledoc """
  One idea I have for accomplishing the task of getting the "next time" two or more trains arrive 
  would be to use the range idea I proposed just above. By storing a range for each of the *current schedules*, 
  you could:

    *Look for schedules that have a range which contain the timestamp argument you recieve. 

    *We are looking to return *two* or more trains that arrive at the same time, 
    otherwise we return none. So now that we have all schedules ids, their ranges, 
    and their schedule lists, we look into each list for all the times that come *just next* 
    after the timestamp argument we recieved. 
    
    *Use a reduce to filter for this and return a list of tuples containing the schedule id and schedules. 
    This list would then be used to count.....

    *If the number of lists (schedules) that contain a matching "just next" time is two or greater than two, 
    we return those two or more schedules. 

    *If we do not find two or more, we now must obtain all the current schedules with a start time earlier 
    than the timestamp argument, including those with an end time earlier than the timestamp (because now 
    we are concerned with next day). 

    *From those schedules we will have to look for the earliest matching start time. In order to return two 
    times or none, I think the fastest way to get there would be to sort the schedules by range, chronologically 
    so that the first schedule you'd find in sorted list would be the earliest time. We now look to see if the second 
    schedule in the list matches with the same earliest start time. If it does, we return those two schedules. If it 
    does not, we continue the loop and look at the next schedule to see if the start time matches. 

  """

  @doc """
  Hello world.

  ## Examples

      iex> TrainTracker.hello()
      :world

  """
  def hello do
    :world
  end
end
