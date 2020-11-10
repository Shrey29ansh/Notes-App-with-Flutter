/* AnimatedPositioned(
                  bottom: bottomheight,
                  left: MediaQuery.of(context).size.width * 0.48,
                  right: MediaQuery.of(context).size.width * 0.48,
                  child: AnimatedContainer(
                    width: _width,
                    height: _width,
                    decoration: BoxDecoration(
                      color: colors[xf],
                      borderRadius: _borderRadius,
                    ),
                    // Define how long the animation should take.
                    duration: Duration(milliseconds: 1000),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.ease,
                  ),
                  curve: motion ? Curves.easeInOut : Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 900)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: CircleAvatar(
                    backgroundColor: colors[xf],
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.bounceIn,
                      opacity: change ? 1 : 0,
                      child: Icon(customicon[xf], color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ), */
