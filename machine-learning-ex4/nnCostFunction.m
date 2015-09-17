function [J grad] = nnCostFunction(nn_params, ...
    input_layer_size, ...
    hidden_layer_size, ...
    num_labels, ...
    X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
    hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
    num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
a1 = [ones(m,1) X];
z2 = Theta1 * a1';
a2 = sigmoid(z2);
a2 = [ones(m,1) a2'];
z3 = Theta2 * a2';
h_theta = sigmoid(z3)';

for k = 1:num_labels
    yk = y == k;
    Jk = (1 / m) * sum(-yk .* log(h_theta(:,k) ) - (1 - yk) .* log(1 - h_theta(:,k)));
    J = J + Jk;
end


regularization = lambda / (2 * m) * (sum(sum(Theta1(:, 2:end) .^ 2)) + sum(sum(Theta2(:, 2:end) .^ 2)));
J = J + regularization;
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the
%               first time.
%

yVector = repmat([1:num_labels], m, 1) == repmat(y, 1, num_labels);
Delta_1 = zeros(size(Theta1));
Delta_2 = zeros(size(Theta2));
for ii = 1:m
 a_1t = a1(1,:);
 a_2t = a2(1,:);
 h_theta_t = h_theta(1,:);
 yVec_t = yVector(ii,:);
 delta_3 = h_theta_t - yVec_t;
 delta_2 = delta_3 * Theta2 .* a_2t;
 Delta_1 = Delta_1 + delta_2(2:end)' * a_1t;
 Delta_2 = Delta_2 + delta_3' * a_2t;
end

Theta1_grad = (1/m) * Delta_1;
Theta2_grad = (1/m) * Delta_2;
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

Theta1_grad = Theta1_grad +  [ zeros(size(Theta1, 1), 1) Theta1(:, 2:end) ] *(lambda/m) .* Theta1;
Theta2_grad = Theta2_grad +  [ zeros(size(Theta2, 1), 1) Theta2(:, 2:end) ] *(lambda/m) .* Theta2;

















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end