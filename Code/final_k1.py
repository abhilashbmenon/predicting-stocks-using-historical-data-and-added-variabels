from keras.models import Sequential
from keras.layers import Dense
#from keras.utils.visualize_util import plot
import matplotlib.pyplot as plt
#from keras.utils.dot_utils import Grapher
import numpy


# fixing random seed for reproducibility
seed = 7
numpy.random.seed(seed)
# loading the stocks dataset with 4 predictors and one binary outcome 
dataset = numpy.loadtxt("snpzscore_rev.csv", delimiter=",")
# splitting into input (X) and output (Y) variables
X = dataset[:,0:14]
Y = dataset[:,14]
# creating model
model = Sequential()
#model.add(Dense(28, input_dim=14, init='uniform', activation='relu'))
model.add(Dense(28, input_dim=14, init='uniform', activation='relu'))  # 14-28; 14 inputs; one hidden with 28 neurons 
#model.add(Dense(28, init='uniform', activation='relu'))
model.add(Dense(1, init='uniform', activation='sigmoid')) #1 output


# Compile model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
# Fit the model
history = model.fit(X, Y, nb_epoch=150, batch_size=5)
#history = model.fit(X, Y, validation_split=0.33, nb_epoch=5, batch_size=5)
#evaluate the model
scores = model.evaluate(X, Y)
print("%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))
predictions = model.predict(X)
rounded = [round(x[0]) for x in predictions]
print(rounded)
#plot_model(model, to_file='model.png')
#print(history.history.keys())
#SVG(model_to_dot(model).create(prog='dot', format='svg')

#svg_img = to_graph(model).create(prog='dot', format='svg')
#SVG(svg_img)