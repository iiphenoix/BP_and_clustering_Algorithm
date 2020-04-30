import share
import  numpy as np
Synthesis,Aggregation,Compound,R15,Flame,Spiral = share.Load()
# X = Synthesis[:,0:2]
X = Aggregation[:,0:2]
#


distance = []
XX= []
YY = []
for i in range(X.shape[0]):
    for j in range(i+1,X.shape[0]):
        XX.append(i+1)
        YY.append(j+1)
        distance.append(np.sqrt(  (X[i,0]-X[j,0])**2+(X[i,1]-X[j,1])**2  ))
xx = np.array([XX,YY,distance])
xx = np.transpose(xx)
import pandas as pd
csv = pd.DataFrame(xx)

ND=max(xx[:,1])
NL=max(xx[:,0])
if(NL>ND):
    ND = NL
N = xx.shape[0]
ND = int(ND)
dist = np.zeros((int(ND),int(ND)))

for i in range(N):
    ii=int(xx[i,0] -1)
    jj=int(xx[i,1] -1)
    dist[ii,jj] = xx[i,2]
    dist[jj,ii] = xx[i,2]

percent=2.0
position=round(N*percent/100)
sda=sorted(xx[:,2])
dc=sda[position-1]
rho = np.zeros((int(ND)))

for i in range(ND-1):
    for j in range(i+1,ND):
        rho[i] = rho[i]+np.exp(-(dist[i,j]/dc)*(dist[i,j]/dc))
        rho[j] = rho[j]+np.exp(-(dist[i,j]/dc)*(dist[i,j]/dc))

maxd = np.max(dist)
rho_sorted  = sorted(rho ,reverse=True)
ordrho = rho.argsort()[::-1]
delta = np.zeros((ND))
nneigh = np.zeros((ND))
delta[ordrho[0]] = -1
nneigh[ordrho[0]] = 0
for ii in range(1,ND):
    delta[ordrho[ii]] = maxd
    for jj in range(ii):
        if(dist[ordrho[ii],ordrho[jj]]<delta[ordrho[ii]]) :
            delta[ordrho[ii]] = dist[ordrho[ii],ordrho[jj]]
            nneigh[ordrho[ii]] = ordrho[jj] + 1
delta[ordrho[0]]=np.max(delta)

import matplotlib.pyplot as plt
print("请选定并且记住所要选取的矩形左下角坐标")
plt.plot(rho,delta,'*')
plt.title ('Decision Graph')
plt.xlabel ('rho')
plt.ylabel ('delta')
plt.show()
plt.savefig('D:\\plot.jpg')


rhomin = input("请输入矩形左下角的x坐标 ：")
deltamin = input("请输入矩形左下角的y坐标 ：")
rhomin = float(rhomin)
deltamin = float(deltamin)

# rhomin = 0.0577
# deltamin = 9.2576

NCLUST = 0
cl = []
for i in range(ND):
    cl.append(-1)
icl = []
for i in range(ND):
    if ((rho[i] > rhomin) & (delta[i] > deltamin)):
        NCLUST = NCLUST + 1
        cl[i] = NCLUST
        icl.append(i)
for i in range(ND):
    if (cl[ordrho[i]] == -1):
        cl[ordrho[i]] = cl[int(nneigh[ordrho[i]]) - 1];
halo = cl
bord_rho = []
if (NCLUST > 1):
    for i in range(NCLUST):
        bord_rho.append(0)
for i in range(ND - 1):
    for j in range(i + 1, ND):
        if ((cl[i] != cl[j]) & (dist[i, j] <= dc)):
            rho_aver = (rho[i] + rho[j]) / 2
            if (rho_aver > bord_rho[cl[i] - 1]):
                bord_rho[cl[i] - 1] = rho_aver
            if (rho_aver > bord_rho[cl[j] - 1]):
                bord_rho[cl[j] - 1] = rho_aver;
for i in range(ND):
    if (rho[i] < bord_rho[cl[i] - 1]):
        halo[i] = 0
for i in range(NCLUST):
    nc = 0
    nh = 0
    for j in range(ND):
        if (cl[j] == i):
            nc = nc + 1
    if (halo[j] == i):
        nh = nh + 1


for i in range(NCLUST ):
    ic=int((i*64.)/(NCLUST*1.))
    plt.plot(rho[icl[i]-1],delta[icl[i]],'o')
plt.show()

from sklearn.manifold import MDS
mds2 = MDS(n_components=2)
Y1= Synthesis[:,0:2]

plt.plot(Y1[:,0],Y1[:,1],'o')
plt.title ('2D Nonclassical multidimensional scaling')
plt.xlabel ('X')
plt.ylabel ('Y')
plt.show()

A = np.zeros((ND,2))


for i in range(0,NCLUST+1 ):
    nn=0
    ic=int((i*64.)/(NCLUST*1.))
    for j in range(ND):
        if (halo[j]==i):
            A[nn,0]=Y1[j,0]
            A[nn,1]=Y1[j,1]
            nn=nn+1
            plt.plot(A[:nn,0],A[:nn,1],'*')
plt.show()