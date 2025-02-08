% Traffic Light Simulation (Improved Version)
clc; clear; close all;

%% Simulation Parameters
simulationTime = 60;   % Total simulation time in seconds
timeStep = 0.1;        % Time step in seconds
currentTime = 0;       % Initialize current time

%% Traffic Light Parameters
trafficStates = {'Red', 'Green', 'Yellow'}; % Define the order of states
durations = struct('Red', 10, 'Green', 15, 'Yellow', 3); % Duration for each state (seconds)
currentStateIndex = 1;          % Start with 'Red'
trafficLightState = trafficStates{currentStateIndex};
lightTimer = 0;                 % Timer for the current state

%% Vehicle Parameters
arrivalRate = 0.3;  % Probability of a vehicle arriving per time step
queueLength = 0;    % Counter to represent the number of vehicles waiting

%% Visualization Setup
figure;
hAx = axes;
% Initialize a bar plot for the vehicle queue
barHandle = bar(hAx, 1, queueLength, 'FaceColor', 'blue'); 
xlim(hAx, [0, 10]); ylim(hAx, [0, 20]);
title(hAx, 'Traffic Simulation');
xlabel(hAx, 'Lane Position');
ylabel(hAx, 'Queue Length');
% Create text handles for displaying the traffic light state and queue length
textHandle1 = text(2, 18, sprintf('Traffic Light: %s', trafficLightState), 'FontSize', 12, 'Color', 'red');
textHandle2 = text(2, 16, sprintf('Queue Length: %d', queueLength), 'FontSize', 12, 'Color', 'blue');

%% Simulation Loop
while currentTime <= simulationTime
    % Step 1: Update Traffic Light Timer and State
    lightTimer = lightTimer + timeStep;
    if lightTimer >= durations.(trafficLightState)
        % Move to the next state (cycling back to the first after the last)
        currentStateIndex = mod(currentStateIndex, numel(trafficStates)) + 1;
        trafficLightState = trafficStates{currentStateIndex};
        lightTimer = 0;
    end
    
    % Step 2: Vehicle Arrival
    if rand <= arrivalRate
        queueLength = queueLength + 1;
    end
    
    % Step 3: Vehicle Movement (only when Green and vehicles are waiting)
    if strcmp(trafficLightState, 'Green') && queueLength > 0
        queueLength = queueLength - 1;
    end
    
    % Step 4: Update Visualization Efficiently
    set(barHandle, 'YData', queueLength);
    set(textHandle1, 'String', sprintf('Traffic Light: %s', trafficLightState));
    set(textHandle2, 'String', sprintf('Queue Length: %d', queueLength));
    drawnow;
    
    % Step 5: Update Simulation Time and Pause
    currentTime = currentTime + timeStep;
    pause(0.05); % Pause to slow down the visualization
end

disp('Simulation Complete!');
