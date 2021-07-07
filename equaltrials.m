% Author: Carter Luck
% Richard Addante's Lab, Florida Tech

function equaltrials(EEG)

% This is the data structure for our event codes. It's a 1xN cell array 
% where N is the number of event code "types" (we are performing the 
% algorithm several times with different event codes). Each element is a 
% new 1xM cell array where M is the different "groups" we are comparing
% accross within a given type (in this case, they represent "old" versus
% "new"). Each element of this cell array is a matrix that contains the 
% event codes that belong to the group.
eventCodeArray = {...
    {[6111 6112 6113 6114 6115 6511 6512 6513 6514 6515] [6311 6312 6313 6314 6315]}...
    {[6121 6122 6123 6124 6125 6521 6522 6523 6524 6525] [6321 6322 6323 6324 6325]}...
    {[6131 6132 6133 6134 6135 6531 6532 6533 6534 6535] [6331 6332 6333 6334 6335]}...
    {[6141 6142 6143 6144 6145 6541 6542 6543 6544 6545] [6341 6342 6343 6344 6345]}...
    {[6151 6152 6153 6154 6155 6551 6552 6553 6554 6555] [6351 6352 6353 6354 6355]}...
    };

finalEventList = [];

% iterate through types
for eventCodeIndex = 1:length(eventCodeArray)
    % get related event code map
    eventCode = eventCodeArray{1,eventCodeIndex};
    % create empty cell array that will contain matrices containing events
    % with event codes that corrospond to the group as defined in
    % eventCodeIndex
    eventMap = cell(1,length(eventCode));
    % iterate through all events
    for eventIndex = 1:length(EEG.event)
        % determine which group if any, the given event maps to within the
        % type
        for groupIndex = 1:length(eventCode)
            if ismember(EEG.event(eventIndex).type,eventCode{1,groupIndex})
                % append event to the vector in eventMap
                eventMap{1,groupIndex} = [eventMap{1,groupIndex} EEG.event(eventIndex)];
            end
        end
    end
    % remove extraneous empty cell at beginning of every array
    for i = 1:length(eventMap)
        eventMap{1,i}(1) = [];
    end
    
    % find minimum number of events
    min = length(eventMap{1,1});
    for i = 1:length(eventMap)
         if length(eventMap{1,i}) < min
             min = length(eventMap{1,i});
         end
    end
    
    % select random trials
    selected = zeros(min*length(eventMap.keys));
    for i = 1:length(eventMap)
        allEvents = eventMap{1,i};
        permutation = randperm(length(allEvents));
        selected(min*(i-1)+1:min*i) = allEvents(permutation(1:min));
    end
    
    finalEventList(end+1:end+length(selected)) = selected;

end 