% Name: Amee Bhuva
% Roll Number: 1401009
% AOBD Final Exam - Semester 6 (2017)


clear all;
close all;
D = dir(['AOBD_files', '\*.txt']);
totalFiles = length(D(~([D.isdir])));
data = [];
for num=1:totalFiles
    fid = fopen('num.txt');        %file names are like 1.txt, 2.txt, 3.txt etc..
    %data matrix: 1-user has skill,  0:missing skill
    while ~feof(fid)
        allSkills = struct('ID','skills');
        data = json.dump(allSkills);
        data = json.load(data);  %data contains all skills with users in 2-D array form
                                    %data matrix: 1-user has skill,  0:missing skill
        
        allJobs = struct('ID','Work-Experience.Job Title');
        jobTitles = json.dump(allJobs);
        jobTitles = json.load(jobTitles);   %jobTitles contains all jobs with users in 2-D array form
    end
    
    
end

[m,n] = size(data);
emptySkill = [];


%Module-2
%goal according to the skills
for i=1:m      
    for j=1:n
    if(data(i,j) == 0)
        emptySkill(i) =1;   %finding rows having 0 in it
        break;
    else
        emptySkill(i) =0;
    end
    end
end


emptySkill;
count=0;
temp=1;
for i=1:length(emptySkill)
    if(emptySkill(i)==1)        %if row is missing any skill
        for j=1:m
            if(i ~= j)
                for k=1:n
                
                    if (data(j,k)==data(i,k))   %checking with other user for skill match
                        count=count+1;
                    end
                end
                 
            end
            skillRequired(temp) = count;    %number of skills matched
            
            count = 0;
            temp=temp+1;
        end
        tempGoal = skillRequired(1);
        requiredGoal(i) = 1;
        for p=1:length(skillRequired)
            if(tempGoal < skillRequired(p))     %finding highest number of skills matched
                requiredGoal(i) = jobTitles(i,p);
            end         
        end
    else
        requiredGoal(i) = 0;            %if no skills are missing with respect to other users
       
    end
end


%Module-1
%path accoding to skills
k=1;

for i=1:length(requiredGoal)
    if (requiredGoal(i) ~= 0)
        for j=1:n
            if(data(requiredGoal(i),j)==1 && data(i,j)==0)  %finding relavant skills
                path(k,1) = j;
                path(k,2) = i;
                k=k+1;
            end
        end
        
    end
end