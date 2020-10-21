Xtest(2,3) = (Xtest(1,3) + Xtest(3,3)) / 2;
Xtest(3,2) = (Xtest(3,1) + Xtest(3,3)) / 2;
Xtest(2,5) = (Xtest(1,5) + Xtest(3,5)) / 2;
Xtest(5,2) = (Xtest(5,1) + Xtest(5,3)) / 2;
Xtest(6,3) = (Xtest(7,3) + Xtest(5,3)) / 2;
Xtest(3,6) = (Xtest(3,7) + Xtest(3,5)) / 2;
Xtest(5,6) = (Xtest(5,7) + Xtest(5,5)) / 2;
Xtest(6,5) = (Xtest(7,5) + Xtest(5,5)) / 2;

Ytest(2,3) = (Ytest(1,3) + Ytest(3,3)) / 2;
Ytest(3,2) = (Ytest(3,1) + Ytest(3,3)) / 2;
Ytest(2,5) = (Ytest(1,5) + Ytest(3,5)) / 2;
Ytest(5,2) = (Ytest(5,1) + Ytest(5,3)) / 2;
Ytest(6,3) = (Ytest(7,3) + Ytest(5,3)) / 2;
Ytest(3,6) = (Ytest(3,7) + Ytest(3,5)) / 2;
Ytest(5,6) = (Ytest(5,7) + Ytest(5,5)) / 2;
Ytest(6,5) = (Ytest(7,5) + Ytest(5,5)) / 2;

Xtest([2 4 6],[2 4 6]) = (Xtest([1 3 5],[1 3 5])...
                        + Xtest([1 3 5],[3 5 7])...
                        + Xtest([3 5 7],[1 3 5])...
                        + Xtest([3 5 7],[3 5 7])) / 4;

Ytest([2 4 6],[2 4 6]) = (Ytest([1 3 5],[1 3 5])...
                        + Ytest([1 3 5],[3 5 7])...
                        + Ytest([3 5 7],[1 3 5])...
                        + Ytest([3 5 7],[3 5 7])) / 4;