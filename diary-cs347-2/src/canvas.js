import React, { useRef, useEffect } from 'react';
import Paper from 'paper';

const Canvas = props => {

    const draw1 = () => {
        let myPath = new Paper.Path();

        Paper.view.onMouseDown = (event) => {
            myPath.strokeColor = "white";
            myPath.strokeWidth = 3;
        };

        Paper.view.onMouseDrag = (event) => {
            myPath.add(event.point);
        };

        Paper.view.draw();
    };


    const canvasRef = useRef(null)

    useEffect(() => {
        const canvas = canvasRef.current;
        Paper.setup(canvas);
        draw1();
    }, []);

    return <canvas ref={canvasRef} {...props} id="canvas" resize="true" />
}

export default Canvas;