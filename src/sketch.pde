import java.util.Random;


int defButtonWidth = 100;
int defButtonHeight = 50;

int trayHeight = 75;

int curPlot = 0;

int inputSwitchCount = 5;
int outputSwitchCount = 5;


PVector startLine = new PVector();
PVector vectorDif = new PVector();

PFont robotoFont = new PFont();

ArrayList<Button> buttonList = new ArrayList<Button>();
ArrayList<Plot> plotList = new ArrayList<Plot>();

IOButton decreaseInput, increaseInput, decreaseOutput, increaseOutput;
IOButton newPlotButton;

Random rand = new Random();


void setup() {
	size(1600, 1000);
	pixelDensity(2);

	robotoFont = createFont("Roboto/Roboto-Medium.ttf", 40);


	plotList.add(new Plot());

	buttonList.add(new Button("AND", new PVector(0.0, 0.0), new PVector(defButtonWidth, defButtonHeight), color(20, 100, 200)));
	buttonList.add(new Button("NOT", new PVector(0.0, 0.0), new PVector(defButtonWidth, defButtonHeight), color(200, 0, 20)));

	for (int i = 0; i < buttonList.size(); i++) {
		buttonList.get(i).setTopLeft((width * (i + 1) / (buttonList.size() + 1)) - defButtonWidth / 2, height - defButtonHeight - 25/2);
	}

	for (int i = 0; i < inputSwitchCount; i++) {
		plotList.get(0).addInput();
	}

	for (int i = 0; i < outputSwitchCount; i++) {
		plotList.get(0).addOutput();
	}


	println(plotList.get(0).plotInputCount);


	decreaseInput = new IOButton(new PVector(30, 10), new PVector(40, 40), color(255));
	increaseInput = new IOButton(new PVector(30, height - 125), new PVector(40, 40), color(255));
	decreaseOutput = new IOButton(new PVector(width - 70, 10), new PVector(40, 40), color(255));
	increaseOutput = new IOButton(new PVector(width - 70, height - 125), new PVector(40, 40), color(255));

	newPlotButton = new IOButton(new PVector(width / 2 - 40, 10), new PVector(80, 40), color(255));
}


void draw() {
	background(40);
	fill(70);
	noStroke();
	rect(0, height - trayHeight, width, trayHeight);


	for (int i = 0; i < buttonList.size(); i++) {
		buttonList.get(i).show();
	}

	plotList.get(curPlot).show();
	plotList.get(curPlot).process();


	decreaseInput.show();
	increaseInput.show();
	decreaseOutput.show();
	increaseOutput.show();

	newPlotButton.show();
}


void keyPressed() {
	plotList.get(curPlot).removeGate();
	plotList.get(curPlot).removeWire();
}


void mouseClicked() {

}


void mousePressed() {
	plotList.get(curPlot).grab();

  for (int i = 0; i < buttonList.size(); i++) {
    if (buttonList.get(i).checkClick()) {
      PVector midScreen = new PVector(width / 2, height / 2);

      if ("NOT".equals(buttonList.get(i).getLabel())) {
        Gate tmp = new Gate(buttonList.get(i).getLabel(), curPlot, midScreen, new PVector(70, 30));
        tmp.setColor(color(200, 0, 20));
        plotList.get(curPlot).addGate(tmp);
      }
      else if ("AND".equals(buttonList.get(i).getLabel())) {
        Gate tmp = new Gate(buttonList.get(i).getLabel(), curPlot, midScreen, new PVector(70, 60), 2, 1);
        tmp.setColor(color(20, 100, 200));
        plotList.get(curPlot).addGate(tmp);
      }
      else {
        int inputSize = plotList.get(i - 2).getInputListSize();
        int outputSize = plotList.get(i - 2).getOutputListSize();
        int gateHeight = Math.max(inputSize, outputSize);

        //println(inputSize + " " + outputSize);

        Gate tmp = new Gate(buttonList.get(i).getLabel(), curPlot, midScreen, new PVector(70, gateHeight * 30), inputSize, outputSize);
        tmp.setColor(buttonList.get(i).getColor());
        plotList.get(curPlot).addGate(tmp);
      }
    }
    else if (buttonList.get(i).checkDeleteClick()) {
      buttonList.remove(i);

      for (int j = 0; j < buttonList.size(); j++) {
        buttonList.get(j).setTopLeft((width * (j + 1) / (buttonList.size() + 1)) - defButtonWidth / 2, height - defButtonHeight - 25/2);
      }
    }
    else if (buttonList.get(i).checkEditClick()) {
      curPlot = i - 2;
    }
  }

  if (decreaseInput.checkClick()) {
    plotList.get(curPlot).removeInput();
  }
  else if (increaseInput.checkClick()) {
    plotList.get(curPlot).addInput();
  }
  else if (decreaseOutput.checkClick()) {
    plotList.get(curPlot).removeOutput();
  }
  else if (increaseOutput.checkClick()) {
    plotList.get(curPlot).addOutput();
  }
  else if (newPlotButton.checkClick()) {
    plotList.get(curPlot).calculatePlotLength();

    plotList.add(new Plot());
    
    curPlot = plotList.size() - 1;

    plotList.get(curPlot).addInput();
    plotList.get(curPlot).addOutput();

    color col = color(rand.nextInt(256), rand.nextInt(256), rand.nextInt(256));
    buttonList.add(new Button(String.valueOf(buttonList.size() - 2), new PVector(0.0, 0.0), new PVector(defButtonWidth, defButtonHeight), col));
    buttonList.get(buttonList.size() - 1).setDeletability(true);
    buttonList.get(buttonList.size() - 1).setEditability(true);

    for (int i = 0; i < buttonList.size(); i++) {
      buttonList.get(i).setTopLeft((width * (i + 1) / (buttonList.size() + 1)) - defButtonWidth / 2, height - defButtonHeight - 25/2);
    }
  }


  plotList.get(curPlot).setInputState();
}


void mouseReleased() {
	plotList.get(curPlot).drop();
}
