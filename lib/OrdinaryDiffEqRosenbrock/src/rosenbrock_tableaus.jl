struct RodasTableau{T, T2}
    A::Matrix{T}
    C::Matrix{T}
    b::Vector{T}
    btilde::Vector{T}
    gamma::T
    c::Vector{T2}
    d::Vector{T}
    H::Matrix{T}
end

struct Rosenbrock23Tableau{T}
    c₃₂::T
    d::T
end

function Rosenbrock23Tableau(T)
    c₃₂ = convert(T, 6 + sqrt(2))
    d = convert(T, 1 / (2 + sqrt(2)))
    Rosenbrock23Tableau(c₃₂, d)
end

struct Rosenbrock32Tableau{T}
    c₃₂::T
    d::T
end

function Rosenbrock32Tableau(T)
    c₃₂ = convert(T, 6 + sqrt(2))
    d = convert(T, 1 / (2 + sqrt(2)))
    Rosenbrock32Tableau(c₃₂, d)
end


function ROS3PTableau(T, T2)
    gamma = convert(T, 1 / 2 + sqrt(3) / 6)
    igamma = inv(gamma)
    A = T[
        0      0 0
        igamma 0 0
        igamma 0 0
    ]
    tmp = -igamma * (convert(T, 2) - convert(T, 1 / 2) * igamma)
    C = T[
        0                    0    0
        -igamma^2            0    0
        -igamma * (1 - tmp)  tmp  0
    ]
    tmp = igamma * (convert(T, 2 // 3) - convert(T, 1 // 6) * igamma)
    b = T[igamma * (1 + tmp), tmp, igamma / 3]
    btilde = T[2.113248654051871, 1, 0.4226497308103742]
    c = T2[0, 1, 1]
    d = T[0.7886751345948129, -0.2113248654051871, -1.077350269189626]
    H = zeros(T, 2, 3)
    RodasTableau(A, C, b, btilde, gamma, c, d, H)
end

function Rodas3Tableau(T, T2)
    gamma = convert(T, 1 // 2)
    A = T[
        0  0  0  0
        0  0  0  0
        2  0  0  0
        2  0  1  0
    ]
    C = T[
        0  0  0
        4  0  0
        1 -1  0
        1 -1 -8 // 3
    ]
    b = T[2, 0, 1, 1]
    btilde = T[0, 0, 0, 1]
    c = T[0, 0, 1, 1]
    d = T[1 // 2, 3 // 2, 0, 0]
    H = zeros(T, 2, 4)
    RodasTableau(A, C, b, btilde, gamma, c, d, H)
end

function Rodas3PTableau(T, T2)
    gamma = convert(T, 1 // 3)
    A = T[
        0        0      0        0 0
        4 // 3   0      0        0 0
        4 // 3   0      0        0 0
        2.90625  3.375  0.40625  0 0
        2.90625  3.375  0.40625  0 0
    ]
    C = T[
        0        0        0        0
       -4.0      0        0        0
        8.25     6.75     0        0
        1.21875 -5.0625  -1.96875  0
        4.03125 -15.1875 -4.03125  6.0
    ]
    b = T[2.90625,  3.375,  0.40625, 1, 0]
    btilde = T[0, 0, 0, 1, -1]
    c = T2[0, 4 // 9, 4 // 9, 1, 1]
    d =  T[1 // 3, -1 // 9, 1, 0, 0]
    H = T[
        1.78125  6.75     0.15625  6  1
        4.21875  15.1875  3.09375  9  0
    ]
    h2_2 = T[4.21875, 2.025, 1.63125, 1.7, 0.1]
    RodasTableau(A, C, b, btilde, gamma, c, d, H)#, h2_2)
end

function Rodas23WTableau(T, T2)
    tab = Rodas3PTableau(T, T2)
    RodasTableau(tab.A, tab.C, tab.btilde, tab.b, tab.gamma, tab.c, tab.d, tab.H)#, h2_2)
end
@ROS2(:tableau)

@ROS23(:tableau)

@ROS34PW(:tableau)

@Rosenbrock4(:tableau)

function Rodas4Tableau(T, T2)
    gamma = convert(T, 1 // 4)
    #BET2P=0.0317D0
    #BET3P=0.0635D0
    #BET4P=0.3438D0
    A = T[
        0                  0                  0                  0                  0  0
        1.544              0                  0                  0                  0  0
        0.9466785280815826 0.2557011698983284 0                  0                  0  0
        3.314825187068521  2.896124015972201  0.9986419139977817 0                  0  0
        1.221224509226641  6.019134481288629 12.53708332932087  -0.6878860361058950 0  0
        1.221224509226641  6.019134481288629 12.53708332932087  -0.6878860361058950 1  0
    ]
    C = T[
        0                   0                    0                 0                  0
       -5.6688              0                    0                 0                  0
       -2.430093356833875  -0.2063599157091915   0                 0                  0
       -0.1073529058151375 -9.594562251023355  -20.47028614809616  0                  0
        7.496443313967647  -10.24680431464352  -33.99990352819905 11.70890893206160   0
        8.083246795921522  -7.981132988064893  -31.52159432874371 16.31930543123136  -6.058818238834054
    ]
    b = A[end, :]
    btilde = T[0, 0, 0, 0, 0, 1]
    c = T2[0, 0.386, 0.21, 0.63, 1, 1]
    d = T[0.25, -0.1043, 0.1035, -0.0362, 0, 0]
    H = T[10.12623508344586 -7.487995877610167 -34.80091861555747 -7.992771707568823 1.025137723295662 0
          -0.6762803392801253 6.087714651680015 16.43084320892478 24.76722511418386 -6.594389125716872 0]
    RodasTableau(A, C, b, btilde, gamma, c, d, H)
end

function Rodas42Tableau(T, T2)
    gamma = convert(T, 1 // 4)
    A = T[0.0 0 0 0 0 0
          1.4028884 0 0 0 0 0
          0.6581212688557198 -1.320936088384301 0 0 0 0
          7.131197445744498 16.02964143958207 -5.561572550509766 0 0 0
          22.73885722420363 67.38147284535289 -31.21877493038560 0.7285641833203814 0 0
          22.73885722420363 67.38147284535289 -31.21877493038560 0.7285641833203814 1 0]
    C = T[0 0 0 0 0
          -5.1043536 0 0 0 0
          -2.899967805418783 4.040399359702244 0 0 0
          -32.64449927841361 -99.35311008728094 49.99119122405989 0 0
          -76.46023087151691 -278.5942120829058 153.9294840910643 10.97101866258358 0
          -76.29701586804983 -294.2795630511232 162.0029695867566 23.65166903095270 -7.652977706771382]
    b = A[end, :]
    btilde = T[0, 0, 0, 0, 0, 1]
    c = T2[0, 0.3507221, 0.2557041, 0.681779, 1, 1]
    d = T[0.25, -0.0690221, -0.0009672, -0.087979, 0, 0]
    H = T[-38.71940424117216 -135.8025833007622 64.51068857505875 -4.192663174613162 -2.531932050335060 0
          -14.99268484949843 -76.30242396627033 58.65928432851416 16.61359034616402 -0.6758691794084156 0]
    RodasTableau(A, C, b, btilde, gamma, c, d, H)
end

function Rodas4PTableau(T, T2)
    gamma = convert(T, 1 // 4)
    #BET2P=0.D0
    #BET3P=c3*c3*(c3/6.d0-GAMMA/2.d0)/(GAMMA*GAMMA)
    #BET4P=0.3438D0
    A = T[0 0 0 0 0 0
          3 0 0 0 0 0
          1.831036793486759 0.4955183967433795 0 0 0 0
          2.304376582692669 -0.05249275245743001 -1.176798761832782 0 0 0
          -7.170454962423024 -4.741636671481785 -16.31002631330971 -1.062004044111401 0 0
          -7.170454962423024 -4.741636671481785 -16.31002631330971 -1.062004044111401 1 0]
    C = T[0 0 0 0 0
          -12 0 0 0 0
          -8.791795173947035 -2.207865586973518 0 0 0
          10.81793056857153 6.780270611428266 19.53485944642410 0 0
          34.19095006749676 15.49671153725963 54.74760875964130 14.16005392148534 0
          34.62605830930532 15.30084976114473 56.99955578662667 18.40807009793095 -5.714285714285717]
    b = A[end, :]
    btilde = T[0, 0, 0, 0, 0, 1]
    c = T2[0, 0.75, 0.21, 0.63, 1, 1]
    d = T[0.25, -0.5, -0.023504, -0.0362, 0, 0]
    H = T[25.09876703708589 11.62013104361867 28.49148307714626 -5.664021568594133 0 0
          1.638054557396973 -0.7373619806678748 8.477918219238990 15.99253148779520 -1.882352941176471 0]
    RodasTableau(A, C, b, btilde, gamma, c, d, H)
end

function Rodas4P2Tableau(T, T2)
    gamma = convert(T, 1 // 4)
    A = T[0 0 0 0 0 0
          3 0 0 0 0 0
          0.906377755268814 -0.189707390391685 0 0 0 0
          3.758617027739064 1.161741776019525 -0.849258085312803 0 0 0
          7.089566927282776 4.573591406461604 -8.423496976860259 -0.959280113459775 0 0
          7.089566927282776 4.573591406461604 -8.423496976860259 -0.959280113459775 1 0]
    C = T[0 0 0 0 0
          -12 0 0 0 0
          -6.354581592719008 0.338972550544623 0 0 0
          -8.575016317114033 -7.606483992117508 12.224997650124820 0 0
          -5.888975457523102 -8.157396617841821 24.805546872612922 12.790401512796979 0
          -4.408651676063871 -6.692003137674639 24.625568527593117 16.627521966636085 -5.714285714285718]
    b = A[end, :]
    btilde = T[0, 0, 0, 0, 0, 1]
    c = T2[0, 0.75, 0.321448134013046, 0.519745732277726, 1, 1]
    d = T[0.25, -0.5, -0.189532918363016, 0.085612108792769, 0, 0]
    H = [-5.323528268423303 -10.042123754867493 17.175254928256965 -5.079931171878093 -0.016185991706112 0
         6.984505741529879 6.914061169603662 -0.849178943070653 18.104410789349338 -3.516963011559032 0]
    RodasTableau(A, C, gamma, c, d, H)
end

function Rodas5Tableau(T, T2)
    gamma = convert(T2, 0.19)
    A = T[
        0                  0                 0                   0                  0                 0     0 0
        2.0                0                 0                   0                  0                 0     0 0
        3.040894194418781  1.041747909077569 0                   0                  0                 0     0 0
        2.576417536461461  1.622083060776640 -0.9089668560264532 0                  0                 0     0 0
        2.760842080225597  1.446624659844071 -0.3036980084553738 0.2877498600325443 0                 0     0 0
        -14.09640773051259 6.925207756232704 -41.47510893210728  2.343771018586405  24.13215229196062 0     0 0
        -14.09640773051259 6.925207756232704 -41.47510893210728  2.343771018586405  24.13215229196062 1     0 0
        -14.09640773051259 6.925207756232704 -41.47510893210728  2.343771018586405  24.13215229196062 1     1 0
    ]
    C = T[
        0                    0                   0                     0                   0                    0                    0
        -10.31323885133993   0                   0                     0                   0                    0                    0
        -21.04823117650003   -7.234992135176716  0                     0                   0                    0                    0
        32.22751541853323    -4.943732386540191  19.44922031041879     0                   0                    0                    0
        -20.69865579590063   -8.816374604402768  1.260436877740897     -0.7495647613787146 0                    0                    0
        -46.22004352711257   -17.49534862857472  -289.6389582892057    93.60855400400906   318.3822534212147    0                    0
        34.20013733472935    -14.15535402717690  57.82335640988400     25.83362985412365   1.408950972071624    -6.551835421242162   0
        42.57076742291101    -13.80770672017997  93.98938432427124     18.77919633714503   -31.58359187223370   -6.685968952921985   -5.810979938412932
    ]
    b = A[end, :]
    btilde = T[0, 0, 0, 0, 0, 0, 0, 1]
    c = T2[0, 0.38, 0.3878509998321533, 0.4839718937873840, 0.4570477008819580, 1, 1, 1]
    d = T[gamma, -0.1823079225333714636, -0.319231832186874912, 0.3449828624725343, -0.377417564392089818, 0, 0, 0]

    H = T[
        27.354592673333357  -6.925207756232857   26.40037733258859     0.5635230501052979  -4.699151156849391   -1.6008677469422725  -1.5306074446748028 -1.3929872940716344
        44.19024239501722    1.3677947663381929e-13 202.93261852171622 -35.5669339789154   -181.91095152160645  3.4116351403665033   2.5793540257308067  2.2435122582734066
        -44.0988150021747   -5.755396159656812e-13 -181.26175034586677 56.99302194811676   183.21182741427398   -7.480257918273637   -5.792426076169686  -5.32503859794143
    ]
    RodasTableau(A, C, b, btilde, gamma, c, d, H)
end

function Rodas5PTableau(T, T2)
    gamma = convert(T2, 0.21193756319429014)
    A = T[
        0                    0                    0                    0                    0                    0   0 0
        3.0                  0                    0                    0                    0                    0   0 0
        2.849394379747939    0.45842242204463923  0                    0                    0                    0   0 0
        -6.954028509809101   2.489845061869568    -10.358996098473584  0                    0                    0   0 0
        2.8029986275628964   0.5072464736228206   -0.3988312541770524  -0.04721187230404641 0                    0   0 0
        -7.502846399306121   2.561846144803919    -11.627539656261098  -0.18268767659942256 0.030198172008377946 0   0 0
        -7.502846399306121   2.561846144803919    -11.627539656261098  -0.18268767659942256 0.030198172008377946 1   0 0
        -7.502846399306121   2.561846144803919    -11.627539656261098  -0.18268767659942256 0.030198172008377946 1   1 0
    ]
    C = T[
        0                     0                    0                     0                    0                    0                    0
        -14.155112264123755   0                    0                     0                    0                    0                    0
        -17.97296035885952   -2.859693295451294    0                     0                    0                    0                    0
        147.12150275711716   -1.41221402718213     71.68940251302358     0                    0                    0                    0
        165.43517024871676   -0.4592823456491126   42.90938336958603    -5.961986721573306    0                    0                    0
        24.854864614690072   -3.0009227002832186   47.4931110020768      5.5814197821558125  -0.6610691825249471   0                    0
        30.91273214028599    -3.1208243349937974   77.79954646070892     34.28646028294783   -19.097331116725623  -28.087943162872662   0
        37.80277123390563    -3.2571969029072276   112.26918849496327    66.9347231244047    -40.06618937091002   -54.66780262877968   -9.48861652309627
    ]
    b = A[end, :]
    btilde = T[0, 0, 0, 0, 0, 0, 0, 1]
    c = T2[0, 0.6358126895828704, 0.4095798393397535, 0.9769306725060716, 0.4288403609558664, 1, 1, 1]
    d = T[0.21193756319429014, -0.42387512638858027, -0.3384627126235924, 1.8046452872882734, 2.325825639765069, 0, 0, 0]
    H = T[
        25.948786856663858  -2.5579724845846235  10.433815404888879   -2.3679251022685204  0.524948541321073    1.1241088310450404   0.4272876194431874  -0.17202221070155493
        -9.91568850695171    -0.9689944594115154  3.0438037242978453  -24.495224566215796  20.176138334709044   15.98066361424651   -6.789040303419874  -6.710236069923372
        11.419903575922262   2.8879645146136994   72.92137995996029    80.12511834622643  -52.072871366152654  -59.78993625266729  -0.15582684282751913  4.883087185713722
    ]
    RodasTableau(A, C, b, btilde, gamma, c, d, H)
end

@RosenbrockW6S4OS(:tableau)

#=
# alpha_ij
A = [0 0 0 0 0 0 0 0
     big"0.38" 0 0 0 0 0 0 0
     big"0.1899188971074152"    big"0.1979321027247381"  0 0 0 0 0 0
     big"0.1110729281178426"    big"0.5456026683145674"  big"-0.1727037026450261" 0 0 0 0 0
     big"0.2329444418850307"    big"0.025099380960713898" big"0.1443314046300300"  big"0.054672473406183418" 0 0 0 0
     big"-0.036201017843430883" big"4.208448872731939"   big"-7.549674427720996"  big"-0.2076823626400282" big"4.585108935472517" 0 0 0
     big"7.585261698003052"     big"-15.57426208319938"  big"-8.814406895608121"  big"1.534698996826085"   big"16.07870828397837" big"0.19" 0 0
     big"0.4646018839086969"    big"0"                   big"-1.720907508837576"  big"0.2910480220957973"  big"1.821778861539924" big"-0.046521258706842056" big"0.19" 0]
# bi
B = [big"0.464601884",0,big"-1.72090751",big"0.29104802",big"1.82177886",big"-0.02674488",big"-0.01977638",big"0.19"]

# Beta_ij

Beta = [big"0.19" 0 0 0 0 0 0 0
        big"0.0076920774666285364"  big"0.19" 0 0 0 0 0 0
        big"-0.058129718999580252"  big"-0.063251113355141360"  big"0.19" 0 0 0 0 0
        big"0.7075715596134048"     big"-0.5980299539145789"   big"0.5294131505610923"    big"0.19" 0 0 0 0
        big"-0.034975026573934865"  big"-0.1928476085817357"    big"0.089839586125126941"  big"0.027613185520411822" big"0.19" 0 0 0
        big"7.585261698003052"      big"-15.57426208319938"     big"-8.814406895608121"    big"1.534698996826085"    big"16.07870828397837"  big"0.19" 0 0
        big"0.4646018839086969"     0                           big"-1.720907508837576"    big"0.2910480220957973"   big"1.821778861539924"  big"-0.046521258706842056" big"0.19" 0
        big"0.4646018839086969"     0                           big"-1.720907508837576"    big"0.2910480220957973"   big"1.821778861539924"  big"-0.026744882930135193" big"-0.019776375776706864" big"0.19"]

Gamma = Beta - A
a = A*Gamma
m = B'*inv(Gamma) # = b_i
C = inv(Diagonal(diag(Gamma))) - inv(Gamma)
c = sum(A,2)
D = Beta*inv(Gamma)
d = sum(Gamma,2)

# Dense output
D_i = tanspose(D)*k_i
y1(Θ) = y₀*(1-Θ) + Θ*(y₁ + (Θ-1)*(D₂ + D₄ + (Θ + 1)*(D₃ + ΘD₄)))

# Determining coefficients
gamma = 0.19
c3 = 0.3878509998321533 == alpha3
c4 = 0.4839718937873840 == alpha4
c5 = 0.4570477008819580 == alpha5
beta3 = 6.8619167645278386e-2
beta4 = 0.8289547562599182
beta5 = 7.9630136489868164e-2
alpha64 = -0.2076823627400282
=#
