#include<bits/stdc++.h>

using namespace std;

void SobelTransformX(vector<vector<int> > mat);
void initVerticalMask();
void initHorizontalMask();

vector<vector<int> > verticalMask;
vector<vector<int> > horizontalMask;

int main() {

    int l, b;
    cin >> l >> b;

    vector<vector<int> > mat(l, vector<int>(b));

    for (int i = 0; i < l; i++) {
        for (int j = 0; j < b; j++) {
            cin >> mat[i][j];
        }
    }
    
    initVerticalMask();
    initHorizontalMask();
    
    SobelTransformX(mat);
    return 0;
}


void SobelTransformX(vector<vector<int> > mat) {
    for (int i = 0; i < mat.size(); i++) {
        for (int j = 0; j < mat[i].size(); j++) {
        
            int sumX = 0, sumY = 0;
            
                for (int k = i - 1; k <= i + 1; k++) {
                    for (int m = j - 1; m <= j + 1; m++) {
                    
                        if (k < 0 or k >= mat.size() or m < 0 or m >= mat[i].size())
                            continue;
                        else {
                            sumX += mat[k][m]*verticalMask[k - i + 1][m - j + 1];
                            sumY += mat[k][m]*horizontalMask[k - i + 1][m - j + 1];
                        }

                    }
                }
            int res = (int)(sqrt(sumX*sumX + sumY*sumY));
            if (res < 0) cout << "0 ";
            else if (res > 255) cout << "255 ";
            else cout << res << " ";

        }
        cout << "\n";
     }
     return;
 }
 
void initVerticalMask() {
    verticalMask.resize(3, vector<int>(3));
    verticalMask[0][0] = -1;
    verticalMask[0][1] = 0;
    verticalMask[0][2] = 1;
    verticalMask[1][0] = -2;
    verticalMask[1][1] = 0;
    verticalMask[1][2] = 2;
    verticalMask[2][0] = -1;
    verticalMask[2][1] = 0;
    verticalMask[2][2] = 1;
 }
 
void initHorizontalMask() {
    horizontalMask.resize(3, vector<int>(3));
    horizontalMask[0][0] = -1;
    horizontalMask[0][1] = -2;
    horizontalMask[0][2] = -1;
    horizontalMask[1][0] = 0;
    horizontalMask[1][1] = 0;
    horizontalMask[1][2] = 0;
    horizontalMask[2][0] = 1;
    horizontalMask[2][1] = 2;
    horizontalMask[2][2] = 1;
 }


    
