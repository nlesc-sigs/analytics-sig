(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 11.3' *)

(***************************************************************************)
(*                                                                         *)
(*                                                                         *)
(*  Under the Wolfram FreeCDF terms of use, this file and its content are  *)
(*  bound by the Creative Commons BY-SA Attribution-ShareAlike license.    *)
(*                                                                         *)
(*        For additional information concerning CDF licensing, see:        *)
(*                                                                         *)
(*         www.wolfram.com/cdf/adopting-cdf/licensing-options.html         *)
(*                                                                         *)
(*                                                                         *)
(***************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1088,         20]
NotebookDataLength[    209140,       4507]
NotebookOptionsPosition[    198412,       4346]
NotebookOutlinePosition[    198961,       4367]
CellTagsIndexPosition[    198918,       4364]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["\<\
Estimating Subgraph Generation Models to Understand Large Network Formation\
\>", "Title",
 CellChangeTimes->{{3.7311485430970516`*^9, 3.7311485535042944`*^9}, {
  3.7347687641896825`*^9, 3.7347687695334415`*^9}, {3.737087017951931*^9, 
  3.737087018233037*^9}},ExpressionUUID->"8f6ba89d-3c28-4ee5-949d-\
393fa35e6fce"],

Cell["\<\
Laurens Bogaardt | Netherlands eScience Center | l.bogaardt@esciencecenter.nl\
\[LineSeparator]Frank W. Takes | University of Amsterdam | takes@uva.nl
Project time frame: January 2018 - October 2018\
\>", "Subsubtitle",
 CellChangeTimes->{{3.7362513054613028`*^9, 3.7362514105561385`*^9}, 
   3.7364396586222906`*^9, {3.739613003002882*^9, 
   3.7396130797397566`*^9}},ExpressionUUID->"c185089a-75bc-47b7-98eb-\
f4ae90efd4d9"],

Cell[CellGroupData[{

Cell["Introduction", "Section",
 CellChangeTimes->{{3.7313945520470543`*^9, 3.7313945691579266`*^9}, {
  3.7362514851711984`*^9, 
  3.7362514878591967`*^9}},ExpressionUUID->"7128cf08-7110-4f96-975b-\
dad6a102c09f"],

Cell[TextData[{
 "Social scientists often aim to understand the incentives and mechanisms \
which result in large scale socio-economic structures. Key to this is network \
formation analysis. However, large datasets are not uncommon, leading to a \
computational challenge. For example, political scientists interested in \
global networks of corporate control may need to analyse millions of \
companies to answer their questions [1, 2].\n\nThe Exponential Random Graph \
Model (ERGM) is a frequently used network formation model. Unfortunately, it \
suffers from two fundamental flaws. Firstly, its parameter estimates are \
inconsistent [3, 4]. Secondly, it does not scale well [5]. Recently, an \
alternative network formation model was suggested: the Subgraph Generation \
Model (SUGM) [6, 7, 8].\n\nThis ",
 StyleBox["Mathematica Notebook",
  FontSlant->"Italic"],
 " examines SUGMs and a method of estimating their parameters using the \
subgraph census."
}], "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7362412191826963`*^9, 3.7362413233434696`*^9}, {3.7362514780719137`*^9, 
  3.73625148003666*^9}, {3.7370867928182125`*^9, 3.7370868486309156`*^9}, {
  3.737087099514515*^9, 3.7370871402937536`*^9}, {3.738140206619357*^9, 
  3.738140207219239*^9}},ExpressionUUID->"2b412d49-4302-46f2-a481-\
f763a12c88af"],

Cell[CellGroupData[{

Cell["Initialisation", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.734768836236582*^9}, {
   3.738139477822164*^9, 3.7381394791327777`*^9}, {3.73814021054315*^9, 
   3.738140214669816*^9}},ExpressionUUID->"71cb8f82-5049-405a-85bc-\
4a1dfe6da245"],

Cell[TextData[{
 "At the end of this ",
 StyleBox["Mathematica Notebook",
  FontSlant->"Italic"],
 ", a ",
 StyleBox["Manipulate",
  FontSlant->"Italic"],
 " will be created which allows the user to run simulations. The current work \
is meant to explore the ideas related to SUGMs and is not optimised for \
performance. Therefore, some of these simulations take a long time to \
evaluate. To accommodate this, the timeout threshold for ",
 StyleBox["Dynamic",
  FontSlant->"Italic"],
 " evaluations needs to be increased."
}], "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
   3.7362412191826963`*^9, 3.7362413233434696`*^9}, {3.7362514780719137`*^9, 
   3.73625148003666*^9}, {3.7370867928182125`*^9, 3.7370868486309156`*^9}, {
   3.737087099514515*^9, 3.7370871402937536`*^9}, {3.738140203207812*^9, 
   3.738140203597706*^9}, {3.739593815763386*^9, 3.739593817325884*^9}, {
   3.7395962182082853`*^9, 3.7395962515397463`*^9}, 
   3.7396100550829067`*^9},ExpressionUUID->"203a8a02-ffbf-4e71-b9f1-\
903d8fdf96c9"],

Cell[BoxData[
 RowBox[{"SetOptions", "[", 
  RowBox[{"$FrontEnd", ",", 
   RowBox[{"DynamicEvaluationTimeout", "\[Rule]", "1200"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.7313160788226504`*^9, 3.731316081182308*^9}, {
   3.7313161603783703`*^9, 3.731316160925169*^9}, {3.7327962804672704`*^9, 
   3.732796281373739*^9}, {3.7350306461977296`*^9, 3.735030669943859*^9}, 
   3.7353808645827265`*^9, {3.7377105815481377`*^9, 3.737710587532524*^9}},
 CellLabel->"In[1]:=",ExpressionUUID->"f5be415c-7994-41ae-99ef-bad344b357cd"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Subgraph Generation", "Section",
 CellChangeTimes->{{3.7311485456128216`*^9, 3.731148566553211*^9}, {
  3.73201077994914*^9, 3.732010780105526*^9}, {3.734768757642803*^9, 
  3.73476876054906*^9}},ExpressionUUID->"ffb55aa8-dbfc-4cdf-952b-\
e33f8d6c0061"],

Cell[TextData[{
 "A SUGM is defined by a set of ",
 StyleBox["q",
  FontSlant->"Italic"],
 " small subgraphs such as links, triangles or stars, each with corresponding \
probabilities. For each subgraph ",
 StyleBox["i",
  FontSlant->"Italic"],
 " of ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["m", "i"], TraditionalForm]],ExpressionUUID->
  "2930e5ff-14a0-4338-993f-ac24f911dedd"],
 " nodes, the ",
 StyleBox["n",
  FontSlant->"Italic"],
 " nodes of the entire network are grouped into all possible subsets of ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["m", "i"], TraditionalForm]],ExpressionUUID->
  "8f18c02f-35ee-4e47-a4ec-834bfcb1f529"],
 " nodes. Then, each of these subsets receives the subgraph ",
 StyleBox["i",
  FontSlant->"Italic"],
 " with probability ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["p", "i"], TraditionalForm]],ExpressionUUID->
  "c127cdb6-9d2d-480b-99a5-760ea6f4f59e"],
 " or remains empty with probability ",
 Cell[BoxData[
  FormBox[
   RowBox[{"1", "-", 
    SubscriptBox["p", "i"]}], TraditionalForm]],ExpressionUUID->
  "bfb8855d-1211-4903-936a-a2d357d16f3d"],
 "."
}], "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
   3.736237915037678*^9, 3.7362379160545616`*^9}, {3.7362413320351996`*^9, 
   3.7362414770695925`*^9}, {3.7362509752637787`*^9, 3.736250978152176*^9}, 
   3.739593895707942*^9, {3.739596272805461*^9, 3.7395962748990545`*^9}, 
   3.7396122112174473`*^9, {3.7396150587262316`*^9, 
   3.7396150593825073`*^9}},ExpressionUUID->"41a58947-fa06-4943-acc6-\
fc06a6fe9048"],

Cell[CellGroupData[{

Cell["Input", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.734768836236582*^9}, {
   3.738139477822164*^9, 3.7381394791327777`*^9}, {3.7382207526033564`*^9, 
   3.738220778665848*^9}, {3.7383890350038705`*^9, 
   3.7383890355505877`*^9}},ExpressionUUID->"4462b8c4-0813-41eb-813d-\
ad1622060fed"],

Cell["\<\
This subsection defines 5 types of subgraphs, namely links, 3-paths, \
triangles, 4-stars and 4-cliques.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7392486124897523`*^9, 
  3.7392486239584913`*^9}},ExpressionUUID->"5cbdcff5-5ead-4421-bc52-\
dc6065705985"],

Cell[BoxData[
 RowBox[{
  RowBox[{"subgraphEdgeLists", "=", 
   RowBox[{"Association", "[", 
    RowBox[{
     RowBox[{"\"\<Links\>\"", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"1", "\[UndirectedEdge]", "2"}], "}"}]}], ",", 
     RowBox[{"\"\<Paths\>\"", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"1", "\[UndirectedEdge]", "2"}], ",", 
        RowBox[{"1", "\[UndirectedEdge]", "3"}]}], "}"}]}], ",", 
     RowBox[{"\"\<Triangles\>\"", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"1", "\[UndirectedEdge]", "2"}], ",", 
        RowBox[{"1", "\[UndirectedEdge]", "3"}], ",", 
        RowBox[{"2", "\[UndirectedEdge]", "3"}]}], "}"}]}], ",", 
     RowBox[{"\"\<Stars\>\"", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"1", "\[UndirectedEdge]", "2"}], ",", 
        RowBox[{"1", "\[UndirectedEdge]", "3"}], ",", 
        RowBox[{"1", "\[UndirectedEdge]", "4"}]}], "}"}]}], ",", 
     RowBox[{"\"\<Cliques\>\"", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"1", "\[UndirectedEdge]", "2"}], ",", 
        RowBox[{"1", "\[UndirectedEdge]", "3"}], ",", 
        RowBox[{"1", "\[UndirectedEdge]", "4"}], ",", 
        RowBox[{"2", "\[UndirectedEdge]", "3"}], ",", 
        RowBox[{"2", "\[UndirectedEdge]", "4"}], ",", 
        RowBox[{"3", "\[UndirectedEdge]", "4"}]}], "}"}]}]}], "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{{3.7370890449297733`*^9, 3.7370891211996145`*^9}, 
   3.7370891686500893`*^9, {3.737089282071306*^9, 3.737089282305687*^9}, {
   3.7370902180756197`*^9, 3.7370902191226287`*^9}, 3.737178799206264*^9, {
   3.7380707849675503`*^9, 3.73807079117068*^9}, 3.7381416370674596`*^9, {
   3.7396122484227557`*^9, 3.7396122492822313`*^9}},
 CellLabel->"In[2]:=",ExpressionUUID->"7265e45e-5b74-4dda-bbfc-d362f37d9ee6"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Functions", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, {
  3.7313961390776787`*^9, 3.7313961605924416`*^9}, {3.736251124683565*^9, 
  3.736251127789432*^9}, {3.738139961448365*^9, 3.7381399617577467`*^9}, {
  3.7381401100092525`*^9, 3.738140111161888*^9}, {3.738220751072217*^9, 
  3.738220781384726*^9}, {3.738389036792224*^9, 
  3.7383890369797335`*^9}},ExpressionUUID->"d1677566-2ef4-4d9a-bda6-\
34cb1b4aea21"],

Cell[TextData[{
 "This subsection defines a function which turns the subgraph edge lists \
defined above into a mapping function. It also defines a function which can \
generate graphs based on combinations of subgraphs. The more nodes a subgraph \
has, the more ways there are to group the entire network into subsets. To be \
able to interpret the probability ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["p", "i"], TraditionalForm]],ExpressionUUID->
  "3eea1975-8350-49d4-b7a5-015329e1d554"],
 " as the proportion of nodes participating in a certain subgraph, a function \
is defined which compensates for this larger number of subsets."
}], "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7362509931555195`*^9, 3.736251035907876*^9}, {3.7392485762866364`*^9, 
  3.7392486492552385`*^9}, {3.73959392705783*^9, 3.7395939575420685`*^9}, {
  3.7395963253696747`*^9, 3.7395963470183554`*^9}, {3.7396101466221104`*^9, 
  3.7396104144710603`*^9}, {3.739612292192502*^9, 3.739612301502656*^9}, {
  3.7396285209013357`*^9, 
  3.7396285653651266`*^9}},ExpressionUUID->"6b13224d-76cf-4ba2-917f-\
cf50a5fbf396"],

Cell[BoxData[
 RowBox[{
  RowBox[{"edgeListToEdgeMap", "[", "edgeList_", "]"}], ":=", 
  RowBox[{"Function", "[", 
   RowBox[{
    RowBox[{"{", "x", "}"}], ",", 
    RowBox[{"Evaluate", "[", 
     RowBox[{"Flatten", "[", 
      RowBox[{"Map", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"Quiet", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{"Part", "[", 
              RowBox[{"x", ",", 
               RowBox[{"Part", "[", 
                RowBox[{"#", ",", "1"}], "]"}]}], "]"}], "\[UndirectedEdge]", 
             RowBox[{"Part", "[", 
              RowBox[{"x", ",", 
               RowBox[{"Part", "[", 
                RowBox[{"#", ",", "2"}], "]"}]}], "]"}]}], "}"}], ",", 
           RowBox[{"{", 
            StyleBox[
             RowBox[{"Part", "::", "partd"}], "MessageName"], 
            StyleBox["}", "MessageName"]}]}], "]"}], "&"}], ",", "edgeList"}],
        "]"}], "]"}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7370886022902308`*^9, 3.737088631419385*^9}, {
   3.7370889867506685`*^9, 3.737088989500656*^9}, {3.737089032789294*^9, 
   3.737089035508031*^9}, {3.7370892210633097`*^9, 3.7370892219384646`*^9}, 
   3.7370902264193697`*^9, 3.7381416079704766`*^9, {3.738298682490411*^9, 
   3.7382987106201267`*^9}},
 CellLabel->"In[3]:=",ExpressionUUID->"b3f1e037-ff23-4115-ac94-09008916dfe2"],

Cell[BoxData[
 RowBox[{
  RowBox[{"binomialCompensator", "[", 
   RowBox[{"l_", ",", "n_"}], "]"}], ":=", 
  RowBox[{
   RowBox[{"Binomial", "[", 
    RowBox[{"n", ",", "2"}], "]"}], "/", 
   RowBox[{"Binomial", "[", 
    RowBox[{"n", ",", "l"}], "]"}]}]}]], "Input",
 CellChangeTimes->{{3.7377074679626007`*^9, 3.737707500828471*^9}, 
   3.7381395921679707`*^9},
 CellLabel->"In[4]:=",ExpressionUUID->"a9616a0b-2e52-4ce6-bc2c-402ad7f8a202"],

Cell[BoxData[
 RowBox[{
  RowBox[{"generateVertexSubsets", "[", 
   RowBox[{"l_", ",", "n_", ",", "p_"}], "]"}], ":=", 
  RowBox[{"RandomSample", "[", 
   RowBox[{
    RowBox[{"Subsets", "[", 
     RowBox[{
      RowBox[{"Range", "[", "n", "]"}], ",", 
      RowBox[{"{", "l", "}"}]}], "]"}], ",", 
    RowBox[{"RandomVariate", "[", 
     RowBox[{"BinomialDistribution", "[", 
      RowBox[{
       RowBox[{"Binomial", "[", 
        RowBox[{"n", ",", "l"}], "]"}], ",", 
       RowBox[{
        RowBox[{"binomialCompensator", "[", 
         RowBox[{"l", ",", "n"}], "]"}], "p"}]}], "]"}], "]"}]}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.732952091378067*^9, 3.7329521136895084`*^9}, {
   3.7329523258915253`*^9, 3.732952330954563*^9}, {3.7329524021261015`*^9, 
   3.732952406942213*^9}, {3.732952444010045*^9, 3.7329524458696012`*^9}, {
   3.732952860547691*^9, 3.7329528699705534`*^9}, {3.7329529680399218`*^9, 
   3.732952975168813*^9}, 3.7329530143342495`*^9, {3.7329531530756474`*^9, 
   3.732953157794056*^9}, {3.733288290775251*^9, 3.7332883436102753`*^9}, {
   3.733288402232568*^9, 3.7332884034648857`*^9}, {3.736494747233901*^9, 
   3.7364947685793405`*^9}, {3.738070877467554*^9, 3.7380708812019386`*^9}, {
   3.7380710745702753`*^9, 3.7380710901327815`*^9}, 3.73813959178131*^9, 
   3.73821999372573*^9, {3.739248788188382*^9, 3.7392487969853487`*^9}},
 CellLabel->"In[5]:=",ExpressionUUID->"e12821af-4f69-4eda-b19e-f6fb6ccb1489"],

Cell[BoxData[
 RowBox[{
  RowBox[{"generateGraph", "[", 
   RowBox[{"l_", ",", "n_", ",", "p_", ",", "edgeMap_"}], "]"}], ":=", 
  RowBox[{"Map", "[", 
   RowBox[{"Sort", ",", 
    RowBox[{"Map", "[", 
     RowBox[{"edgeMap", ",", 
      RowBox[{"Map", "[", 
       RowBox[{"RandomSample", ",", 
        RowBox[{"generateVertexSubsets", "[", 
         RowBox[{"l", ",", "n", ",", "p"}], "]"}]}], "]"}]}], "]"}], ",", 
    RowBox[{"{", "2", "}"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7365703849118223`*^9, 3.7365704630840254`*^9}, 
   3.7365705118293777`*^9, {3.7365706060536294`*^9, 3.736570609506754*^9}, {
   3.7365706584801645`*^9, 3.736570660356343*^9}, {3.7365707493118286`*^9, 
   3.7365708764370527`*^9}, {3.736570909299258*^9, 3.736571017692738*^9}, {
   3.7365710888805375`*^9, 3.736571099203555*^9}, {3.7380710539140277`*^9, 
   3.7380710625701666`*^9}, {3.7380711081483974`*^9, 3.7380711183514147`*^9}, 
   3.7382199931632376`*^9},
 CellLabel->"In[6]:=",ExpressionUUID->"c2316eec-5e18-4751-8f83-d2b8ee8ac5c4"],

Cell[BoxData[
 RowBox[{
  RowBox[{"generateGraphList", "[", 
   RowBox[{"vertexCount_", ",", "edgeMap_", ",", "n_", ",", "pMap_"}], "]"}], 
  ":=", 
  RowBox[{"Union", "[", 
   RowBox[{"Flatten", "[", 
    RowBox[{"KeyValueMap", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"generateGraph", "[", 
        RowBox[{
         RowBox[{"vertexCount", "[", "#1", "]"}], ",", "n", ",", "#2", ",", 
         RowBox[{"edgeMap", "[", "#1", "]"}]}], "]"}], "&"}], ",", "pMap"}], 
     "]"}], "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.736571332122161*^9, 3.7365713630494347`*^9}, {
  3.738071187679532*^9, 3.738071189523402*^9}, {3.7381400565877266`*^9, 
  3.7381400902027216`*^9}, {3.738141763837388*^9, 3.7381417728247538`*^9}},
 CellLabel->"In[7]:=",ExpressionUUID->"1e8b3f1e-91d5-4712-99d1-82e4156f30a6"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Derived Input", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.734768836236582*^9}, {
   3.7381394826720123`*^9, 3.7381394841178756`*^9}, {3.7381396619044724`*^9, 
   3.738139662237794*^9}, {3.738140102797998*^9, 3.738140103427737*^9}, {
   3.738220748400343*^9, 3.7382207493064623`*^9}, {3.7382207836189747`*^9, 
   3.738220784259714*^9}, {3.73838903960465*^9, 
   3.738389039807848*^9}},ExpressionUUID->"0aa8c034-c27e-40fd-865c-\
dfb3ba6bc78c"],

Cell["\<\
Some variables need not be set by hand and can be derived from previously \
defined input. This subsection defines variables related to the subgraph edge \
lists.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.739593970572166*^9, 3.739594072978277*^9}, {3.739596372143359*^9, 
  3.739596377971367*^9}, {3.7396104488906555`*^9, 
  3.7396104796702433`*^9}},ExpressionUUID->"855f78c9-86ee-4a90-bafd-\
df92fbaf9656"],

Cell[BoxData[
 RowBox[{
  RowBox[{"subgraphVertexCounts", "=", 
   RowBox[{"Map", "[", 
    RowBox[{"VertexCount", ",", "subgraphEdgeLists"}], "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{{3.7370892522063055`*^9, 3.737089287071165*^9}, {
   3.737090278651856*^9, 3.7370902990420804`*^9}, 3.737091695867652*^9, 
   3.737178802242708*^9, {3.7381396332077703`*^9, 3.7381396357571774`*^9}, 
   3.7381416366323233`*^9, 3.7381417403021865`*^9, {3.7382987416311407`*^9, 
   3.738298743443636*^9}},
 CellLabel->"In[8]:=",ExpressionUUID->"d61edb66-53b7-413e-92f0-25c2428395d6"],

Cell[BoxData[
 RowBox[{
  RowBox[{"subgraphEdgeCounts", "=", 
   RowBox[{"Map", "[", 
    RowBox[{"EdgeCount", ",", "subgraphEdgeLists"}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.738477111127466*^9, 3.738477122219463*^9}},
 CellLabel->"In[9]:=",ExpressionUUID->"b49c78bf-a5b2-4d1a-93cf-abea53deacb7"],

Cell[BoxData[
 RowBox[{
  RowBox[{"subgraphEdgeMaps", "=", 
   RowBox[{"Map", "[", 
    RowBox[{"edgeListToEdgeMap", ",", "subgraphEdgeLists"}], "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{{3.7365704706738644`*^9, 3.7365705515191956`*^9}, {
   3.7365707887928534`*^9, 3.7365707911678715`*^9}, {3.7365710233958397`*^9, 
   3.736571026567395*^9}, {3.7365714271310377`*^9, 3.736571484005557*^9}, {
   3.7370879585830097`*^9, 3.7370879781748047`*^9}, 3.737088026530405*^9, {
   3.737089191761495*^9, 3.7370892247509546`*^9}, {3.737089295493189*^9, 
   3.737089296951476*^9}, {3.7370903031358404`*^9, 3.737090305966066*^9}, 
   3.737092024893582*^9, {3.737178803352087*^9, 3.7371788098519487`*^9}, {
   3.7381416074825134`*^9, 3.7381416366323233`*^9}, {3.7381416900221653`*^9, 
   3.738141697585125*^9}, {3.7382987447009215`*^9, 3.7382987612028875`*^9}, {
   3.739593457529833*^9, 3.739593459701698*^9}},
 CellLabel->"In[10]:=",ExpressionUUID->"9a53b5c3-3713-4cc3-b7b2-d51aefde4cae"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Visualisation Functions", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, {
  3.7313961390776787`*^9, 3.7313961605924416`*^9}, {3.736251141782386*^9, 
  3.7362511501822987`*^9}, {3.7382207064315004`*^9, 3.7382207114472246`*^9}, {
  3.7382209175010366`*^9, 3.7382209215946903`*^9}, {3.7383890485951166`*^9, 
  3.738389048766839*^9}},ExpressionUUID->"5570249b-c4a1-496b-a9f0-\
f70fd1f3d08e"],

Cell["\<\
To be able to distinguish the generated subgraphs from each other in a \
visualisation, it helps to colour them differently. The following function \
does this.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7395942930974073`*^9, 3.739594333425533*^9}, {3.7395964444816065`*^9, 
  3.7395964569190664`*^9}, {3.7396124283517895`*^9, 3.739612432804923*^9}, {
  3.7396153923667393`*^9, 
  3.7396153941637397`*^9}},ExpressionUUID->"94796fc5-7ef6-4608-ab1a-\
fd52dcabf67c"],

Cell[BoxData[
 RowBox[{
  RowBox[{"colouredGraph", "[", 
   RowBox[{"colorList_", ",", "edgeLists_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"uniqueEdges", "=", 
      RowBox[{"DeleteDuplicates", "[", 
       RowBox[{"Flatten", "[", "edgeLists", "]"}], "]"}]}], "}"}], ",", 
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"edgeStyles", "=", 
        RowBox[{"AssociationMap", "[", 
         RowBox[{
          RowBox[{"Function", "[", 
           RowBox[{
            RowBox[{"{", "uniqueEdge", "}"}], ",", 
            RowBox[{"Pick", "[", 
             RowBox[{"colorList", ",", 
              RowBox[{"Map", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"MemberQ", "[", 
                  RowBox[{"#", ",", "uniqueEdge"}], "]"}], "&"}], ",", 
                "edgeLists"}], "]"}]}], "]"}]}], "]"}], ",", "uniqueEdges"}], 
         "]"}]}], "}"}], ",", 
      RowBox[{"Module", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"edgeIndex", "=", 
          RowBox[{"AssociationThread", "[", 
           RowBox[{"uniqueEdges", "\[Rule]", 
            RowBox[{"ConstantArray", "[", 
             RowBox[{"1", ",", 
              RowBox[{"Length", "[", "uniqueEdges", "]"}]}], "]"}]}], "]"}]}],
          "}"}], ",", 
        RowBox[{"Fold", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"(", 
            RowBox[{"SetProperty", "[", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"#1", ",", "#2"}], "}"}], ",", 
              RowBox[{"EdgeShapeFunction", "\[Rule]", 
               RowBox[{"(", 
                RowBox[{
                 RowBox[{"{", 
                  RowBox[{
                   RowBox[{
                    RowBox[{"edgeStyles", "[", "#2", "]"}], "[", 
                    RowBox[{"[", 
                    RowBox[{
                    RowBox[{"edgeIndex", "[", "#2", "]"}], "++"}], "]"}], 
                    "]"}], ",", 
                   RowBox[{"Line", "[", "#", "]"}]}], "}"}], "&"}], ")"}]}]}],
              "]"}], ")"}], "&"}], ",", 
          RowBox[{"Graph", "[", 
           RowBox[{"Flatten", "[", 
            RowBox[{"Map", "[", 
             RowBox[{"Union", ",", "edgeLists"}], "]"}], "]"}], "]"}], ",", 
          "uniqueEdges"}], "]"}]}], "]"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7355528475996695`*^9, 3.735552923430794*^9}, {
   3.735553004014781*^9, 3.735553009305085*^9}, {3.7355534287126646`*^9, 
   3.7355534398430414`*^9}, {3.7355543365040145`*^9, 
   3.7355543388010297`*^9}, {3.735554388353117*^9, 3.7355543953687897`*^9}, {
   3.7355545352297926`*^9, 3.735554556872334*^9}, {3.7355548717076817`*^9, 
   3.7355548718484545`*^9}, 3.7355549057782884`*^9, 3.735554942142222*^9, 
   3.735554978906968*^9, 3.735555028849889*^9, {3.735555066730283*^9, 
   3.735555156857773*^9}, 3.7381398248474755`*^9, {3.739281269939071*^9, 
   3.7392812932290773`*^9}, {3.739281436209298*^9, 3.7392814366494403`*^9}},
 CellLabel->"In[11]:=",ExpressionUUID->"09d73d03-3e58-4474-93f6-76001c0482b7"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Examples", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, {
   3.7313961390776787`*^9, 3.7313961605924416`*^9}, {3.736251124683565*^9, 
   3.736251127789432*^9}, {3.7381395169481287`*^9, 3.738139517952746*^9}, {
   3.738220721869081*^9, 3.7382207470564694`*^9}, {3.738220786384715*^9, 
   3.7382207869158535`*^9}, 
   3.73838904172972*^9},ExpressionUUID->"92d3832b-0022-4489-95e4-\
a8920b19e807"],

Cell["\<\
The first example in this subsection shows multiple graphs generated for each \
of the subgraphs. It also includes various relevant graph metrics. The second \
example shows a single graph combining multiple types of subgraphs. The \
observed network, left in the figure, is the union of all these subgraphs, \
right in figure, where the generated subgraphs may overlap. Multiple \
neighbouring subgraphs may incidentally form additional structures such as \
triangles or squares.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7362509931555195`*^9, 3.736251035907876*^9}, {3.738139513957781*^9, 
  3.7381395146183815`*^9}, {3.7395940873377857`*^9, 3.739594210040914*^9}, {
  3.739596400580844*^9, 3.7395964199869556`*^9}, {3.7396123805838146`*^9, 
  3.739612410137108*^9}, {3.7396124614077897`*^9, 3.739612503315132*^9}, {
  3.73961549160116*^9, 3.739615497554595*^9}, {3.7396286106642885`*^9, 
  3.739628610764181*^9}, {3.7396286921737013`*^9, 
  3.739628728703006*^9}},ExpressionUUID->"5673b6f6-41c3-4033-b97c-\
5341dde8995c"],

Cell[BoxData[
 RowBox[{"Module", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"figureList", "=", 
     RowBox[{"ConstantArray", "[", 
      RowBox[{"Null", ",", "10"}], "]"}]}], "}"}], ",", 
   RowBox[{"Grid", "[", 
    RowBox[{
     RowBox[{"Join", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Button", "[", 
           RowBox[{"\"\<Export Figure 1\>\"", ",", 
            RowBox[{"Do", "[", 
             RowBox[{
              RowBox[{"Export", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"ToString", "[", 
                  RowBox[{"NotebookDirectory", "[", "]"}], "]"}], "<>", 
                 "\"\<\\\\Figure01_\>\"", "<>", 
                 RowBox[{"ToString", "[", "i", "]"}], "<>", "\"\<.pdf\>\""}], 
                ",", 
                RowBox[{"figureList", "[", 
                 RowBox[{"[", "i", "]"}], "]"}]}], "]"}], ",", 
              RowBox[{"{", 
               RowBox[{"i", ",", "1", ",", 
                RowBox[{"Length", "[", "figureList", "]"}]}], "}"}]}], 
             "]"}]}], "]"}], ",", "\"\<Graph\>\"", ",", 
          "\"\<MeanGraphDistance\>\"", ",", 
          "\"\<MeanClusteringCoefficient\>\"", ",", "\"\<VertexDegree\>\""}], 
         "}"}], "}"}], ",", 
       RowBox[{"Table", "[", 
        RowBox[{
         RowBox[{"With", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{"graph1", "=", 
              RowBox[{"Graph", "[", 
               RowBox[{"generateGraphList", "[", 
                RowBox[{"subgraphVertexCounts", ",", "subgraphEdgeMaps", ",", 
                 RowBox[{"iter", "[", 
                  RowBox[{"[", "3", "]"}], "]"}], ",", 
                 RowBox[{"Association", "[", 
                  RowBox[{
                   RowBox[{"iter", "[", 
                    RowBox[{"[", "2", "]"}], "]"}], "\[Rule]", 
                   RowBox[{"iter", "[", 
                    RowBox[{"[", "4", "]"}], "]"}]}], "]"}]}], "]"}], "]"}]}],
              ",", 
             RowBox[{"graph2", "=", 
              RowBox[{"Graph", "[", 
               RowBox[{"generateGraphList", "[", 
                RowBox[{"subgraphVertexCounts", ",", "subgraphEdgeMaps", ",", 
                 RowBox[{"iter", "[", 
                  RowBox[{"[", "5", "]"}], "]"}], ",", 
                 RowBox[{"Association", "[", 
                  RowBox[{
                   RowBox[{"iter", "[", 
                    RowBox[{"[", "2", "]"}], "]"}], "\[Rule]", 
                   RowBox[{"iter", "[", 
                    RowBox[{"[", "6", "]"}], "]"}]}], "]"}]}], "]"}], 
               "]"}]}]}], "}"}], ",", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"iter", "[", 
              RowBox[{"[", "2", "]"}], "]"}], ",", 
             RowBox[{
              RowBox[{"figureList", "[", 
               RowBox[{"[", 
                RowBox[{"iter", "[", 
                 RowBox[{"[", "1", "]"}], "]"}], "]"}], "]"}], "=", 
              "graph1"}], ",", 
             RowBox[{"N", "[", 
              RowBox[{
               RowBox[{"MeanGraphDistance", "[", "graph2", "]"}], ",", "2"}], 
              "]"}], ",", 
             RowBox[{"N", "[", 
              RowBox[{
               RowBox[{"MeanClusteringCoefficient", "[", "graph2", "]"}], ",",
                "2"}], "]"}], ",", 
             RowBox[{
              RowBox[{"figureList", "[", 
               RowBox[{"[", 
                RowBox[{
                 RowBox[{"iter", "[", 
                  RowBox[{"[", "1", "]"}], "]"}], "+", "1"}], "]"}], "]"}], 
              "=", 
              RowBox[{"Histogram", "[", 
               RowBox[{"VertexDegree", "[", "graph2", "]"}], "]"}]}]}], 
            "}"}]}], "]"}], ",", 
         RowBox[{"{", 
          RowBox[{"iter", ",", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{
              "1", ",", "\"\<Links\>\"", ",", "20", ",", "0.1", ",", "400", 
               ",", "0.05"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{
              "3", ",", "\"\<Paths\>\"", ",", "20", ",", "0.05", ",", "240", 
               ",", "0.05"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{
              "5", ",", "\"\<Triangles\>\"", ",", "15", ",", "0.1", ",", 
               "240", ",", "0.05"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{
              "7", ",", "\"\<Stars\>\"", ",", "15", ",", "0.1", ",", "170", 
               ",", "0.05"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{
              "9", ",", "\"\<Cliques\>\"", ",", "15", ",", "0.05", ",", "170",
                ",", "0.05"}], "}"}]}], "}"}]}], "}"}]}], "]"}]}], "]"}], ",", 
     RowBox[{"Spacings", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"1", ",", "1"}], "}"}]}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.7392489755634623`*^9, 3.739249249782092*^9}, {
  3.739249307157094*^9, 3.739249349547711*^9}, {3.739251713344931*^9, 
  3.739251733290698*^9}, {3.73925177676436*^9, 3.7392517981393833`*^9}, {
  3.7392519227176156`*^9, 3.7392519273582506`*^9}},
 CellLabel->"In[12]:=",ExpressionUUID->"e78b6abd-35fe-4c03-a1be-22c113530382"],

Cell[BoxData[
 RowBox[{"DynamicModule", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{
     RowBox[{"refreshDummy", "=", "0"}], ",", 
     RowBox[{"figureList", "=", 
      RowBox[{"ConstantArray", "[", 
       RowBox[{"Null", ",", "2"}], "]"}]}]}], "}"}], ",", 
   RowBox[{"Manipulate", "[", 
    RowBox[{
     RowBox[{"refreshDummy", ";", 
      RowBox[{"With", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"colorList", "=", 
           RowBox[{"{", 
            RowBox[{
            "Red", ",", "Purple", ",", "Green", ",", "Orange", ",", "Blue"}], 
            "}"}]}], ",", 
          RowBox[{"edgeLists", "=", 
           RowBox[{"KeyValueMap", "[", 
            RowBox[{
             RowBox[{
              RowBox[{"Flatten", "[", 
               RowBox[{"generateGraph", "[", 
                RowBox[{
                 RowBox[{"subgraphVertexCounts", "[", "#1", "]"}], ",", "n", 
                 ",", "#2", ",", 
                 RowBox[{"subgraphEdgeMaps", "[", "#1", "]"}]}], "]"}], "]"}],
               "&"}], ",", 
             RowBox[{"Association", "[", 
              RowBox[{
               RowBox[{"\"\<Links\>\"", "\[Rule]", "pL"}], ",", 
               RowBox[{"\"\<Paths\>\"", "\[Rule]", "pP"}], ",", 
               RowBox[{"\"\<Triangles\>\"", "\[Rule]", "pT"}], ",", 
               RowBox[{"\"\<Stars\>\"", "\[Rule]", "pS"}], ",", 
               RowBox[{"\"\<Cliques\>\"", "\[Rule]", "pC"}]}], "]"}]}], 
            "]"}]}]}], "}"}], ",", 
        RowBox[{"With", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"edgeList", "=", 
            RowBox[{"Union", "[", 
             RowBox[{"Flatten", "[", "edgeLists", "]"}], "]"}]}], "}"}], ",", 
          RowBox[{"Grid", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{
              "\"\<Observed graph\>\"", ",", "\"\<Underlying reality\>\""}], 
              "}"}], ",", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{
                RowBox[{"figureList", "[", 
                 RowBox[{"[", "1", "]"}], "]"}], "=", 
                RowBox[{"Show", "[", 
                 RowBox[{
                  RowBox[{"Graph", "[", "edgeList", "]"}], ",", 
                  RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}], ",", 
               RowBox[{
                RowBox[{"figureList", "[", 
                 RowBox[{"[", "2", "]"}], "]"}], "=", 
                RowBox[{"Show", "[", 
                 RowBox[{
                  RowBox[{"colouredGraph", "[", 
                   RowBox[{"colorList", ",", "edgeLists"}], "]"}], ",", 
                  RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}]}], 
              "}"}]}], "}"}], "]"}]}], "]"}]}], "]"}]}], ",", 
     RowBox[{"Grid", "[", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"n", ",", "10"}], "}"}], ",", "5", ",", "30", ",", "1", 
             ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], "}"}], 
           "]"}], ",", 
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"pL", ",", "0.05"}], "}"}], ",", "0.0", ",", "0.1", ",",
              "0.01", ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], "}"}], 
           "]"}]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"pP", ",", "0.04"}], "}"}], ",", "0.0", ",", "0.1", ",",
              "0.01", ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], "}"}], 
           "]"}], ",", 
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"pT", ",", "0.03"}], "}"}], ",", "0.0", ",", "0.1", ",",
              "0.01", ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], "}"}], 
           "]"}]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"pS", ",", "0.02"}], "}"}], ",", "0.0", ",", "0.1", ",",
              "0.01", ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], "}"}], 
           "]"}], ",", 
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"pC", ",", "0.01"}], "}"}], ",", "0.0", ",", "0.1", ",",
              "0.01", ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], "}"}], 
           "]"}]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Button", "[", 
           RowBox[{"\"\<Refresh\>\"", ",", 
            RowBox[{"refreshDummy", "=", 
             RowBox[{"RandomReal", "[", "]"}]}]}], "]"}], ",", 
          RowBox[{"Button", "[", 
           RowBox[{"\"\<Export Figure 2\>\"", ",", 
            RowBox[{"Do", "[", 
             RowBox[{
              RowBox[{
               RowBox[{"Export", "[", 
                RowBox[{
                 RowBox[{
                  RowBox[{"ToString", "[", 
                   RowBox[{"NotebookDirectory", "[", "]"}], "]"}], "<>", 
                  "\"\<\\\\Figure02_\>\"", "<>", 
                  RowBox[{"ToString", "[", "i", "]"}], "<>", "\"\<.pdf\>\""}],
                  ",", 
                 RowBox[{"figureList", "[", 
                  RowBox[{"[", "i", "]"}], "]"}]}], "]"}], ";"}], ",", 
              RowBox[{"{", 
               RowBox[{"i", ",", "1", ",", 
                RowBox[{"Length", "[", "figureList", "]"}]}], "}"}]}], 
             "]"}]}], "]"}], ",", "\"\<\>\""}], "}"}]}], "}"}], "]"}]}], 
    "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.7355530878854203`*^9, 3.7355532236369514`*^9}, {
   3.735553346584317*^9, 3.735553368837308*^9}, {3.7355534560529094`*^9, 
   3.735553499780528*^9}, {3.7355535683580914`*^9, 3.7355536142831945`*^9}, {
   3.735553649980457*^9, 3.735553661011067*^9}, {3.735554194887784*^9, 
   3.735554233574047*^9}, {3.7355545682230563`*^9, 3.735554621712383*^9}, {
   3.7355547001069536`*^9, 3.7355547076694536`*^9}, {3.735554865749965*^9, 
   3.7355548679532347`*^9}, 3.7355549037312737`*^9, 3.7355549412203755`*^9, 
   3.7355549794538403`*^9, 3.73555502820926*^9, {3.73555506602703*^9, 
   3.735555154685751*^9}, {3.7355561282926435`*^9, 3.7355561535325756`*^9}, {
   3.7355749511158257`*^9, 3.735574964744487*^9}, {3.735575043724048*^9, 
   3.735575107867568*^9}, {3.7356313302155404`*^9, 3.7356314110243883`*^9}, {
   3.7356314592811995`*^9, 3.735631524146886*^9}, {3.7356316721096754`*^9, 
   3.7356316723630605`*^9}, {3.7357357699298687`*^9, 3.735735775304886*^9}, 
   3.73649368495747*^9, 3.736494062043361*^9, {3.7364941183738832`*^9, 
   3.73649414782216*^9}, 3.7364941815913954`*^9, {3.736494670999565*^9, 
   3.736494672858943*^9}, {3.736571844152792*^9, 3.7365718506701417`*^9}, {
   3.7365719634111133`*^9, 3.736571994174186*^9}, {3.736572166653339*^9, 
   3.736572167971347*^9}, {3.736572366895255*^9, 3.736572370082748*^9}, {
   3.738071360773404*^9, 3.738071362195281*^9}, 3.738139824547684*^9, {
   3.738141689677127*^9, 3.7381416905261974`*^9}, 3.7381417400426116`*^9, {
   3.738141904442294*^9, 3.738141991402137*^9}},
 CellLabel->"In[13]:=",ExpressionUUID->"e1a573d7-6a95-4653-9b36-27dce1c3e278"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Subgraph Census", "Section",
 CellChangeTimes->{{3.7311485456128216`*^9, 3.731148566553211*^9}, {
   3.7311728763702154`*^9, 3.731172876585377*^9}, {3.7347687870178213`*^9, 
   3.7347687934239264`*^9}, {3.738139383536006*^9, 3.7381393863638973`*^9}, 
   3.7382208206972265`*^9},ExpressionUUID->"6cd23836-a73b-43c9-a898-\
c6a08e71a94e"],

Cell[TextData[{
 "The goal of this ",
 StyleBox["Mathematica Notebook",
  FontSlant->"Italic"],
 " is to explore a method of estimating SUGMs parameters using the subgraph \
census. In a ",
 StyleBox["k",
  FontSlant->"Italic"],
 "-subgraph census, a network of ",
 StyleBox["n",
  FontSlant->"Italic"],
 " nodes is grouped into all possible subsets of ",
 StyleBox["k",
  FontSlant->"Italic"],
 " nodes, which are then tallied according to their isomorphism class [9, 10, \
11]."
}], "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
   3.7362379532418528`*^9, 3.736237962911622*^9}, {3.736241601833735*^9, 
   3.7362416179015417`*^9}, {3.73685889075249*^9, 3.736858894825054*^9}, {
   3.7370868535684175`*^9, 3.737086858474531*^9}, {3.7381393803179417`*^9, 
   3.7381393808428855`*^9}, 3.739595119103582*^9, {3.739610567334902*^9, 
   3.7396105884880896`*^9}},ExpressionUUID->"884dd5a8-24d3-40ac-b1c5-\
0e5572cd9d47"],

Cell[CellGroupData[{

Cell["Input", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.7347688028302975`*^9}, {
   3.7381393890128098`*^9, 3.7381393929282093`*^9}, {3.7381394624870195`*^9, 
   3.7381394635180817`*^9}, 3.7383877578617897`*^9, {3.7383890747681756`*^9, 
   3.7383890749556756`*^9}},ExpressionUUID->"b5c13e16-0a7a-42da-8baa-\
69da5f8687b9"],

Cell["\<\
In the current work, the subgraph census is limited to size 4. One reason for \
this are the computational difficulties which arise with higher order censi. \
Another reason is the degree sequence trick discussed in the next subsection.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7395951311034613`*^9, 3.739595270151494*^9}, {3.7396105997248383`*^9, 
  3.7396106009279623`*^9}, {3.7396106748733125`*^9, 3.7396106809048944`*^9}, {
  3.7396155562576528`*^9, 3.7396155633511143`*^9}, {3.739678930437232*^9, 
  3.739678931265354*^9}},ExpressionUUID->"122f3819-2446-41c5-8e9a-\
5230bc27eab5"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusSizes", "=", 
   RowBox[{"{", 
    RowBox[{"2", ",", "3", ",", "4"}], "}"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.7353668188503513`*^9, 3.7353668271847153`*^9}, 
   3.7381393565126*^9, {3.7383879518281517`*^9, 3.7383879519345913`*^9}, {
   3.7385631355815754`*^9, 3.7385631365971746`*^9}},
 CellLabel->"In[14]:=",ExpressionUUID->"6eeed15d-e16a-4848-a2cb-6e06a1616b73"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Functions", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.7347688028302975`*^9}, {
   3.7381393890128098`*^9, 3.7381393929282093`*^9}, 3.738387759252408*^9, {
   3.738389076189915*^9, 
   3.7383890765650454`*^9}},ExpressionUUID->"49fcf1df-dc64-433c-b0ee-\
db1b21e6f374"],

Cell["\<\
This subsection defines functions which generate all census subgraph types, \
including all their permutations. It also defines a function which performs \
the subgraph census on a graph. For subgraphs up to size 4, the type can be \
identified uniquely by its degree sequence [12]. This allows for an \
optimisation trick in the count function which speeds up the determination of \
the census type. However, it limits the use of this function to census sizes \
of maximally 4.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7395955967679076`*^9, 3.7395956361116467`*^9}, {3.7395957182054043`*^9, 
  3.7395957372835193`*^9}, {3.7395966540283103`*^9, 3.7395966806376905`*^9}, {
  3.7396157123852963`*^9, 3.73961573051044*^9}, {3.7396288153382483`*^9, 
  3.7396288481470213`*^9}},ExpressionUUID->"61804c84-3534-419d-bd68-\
1b6bffdddf92"],

Cell[BoxData[
 RowBox[{
  RowBox[{"edgeListPermutations", "[", "l_", "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"edges", "=", 
      RowBox[{"Map", "[", 
       RowBox[{
        RowBox[{
         RowBox[{
          RowBox[{"#", "[", 
           RowBox[{"[", "1", "]"}], "]"}], "\[UndirectedEdge]", 
          RowBox[{"#", "[", 
           RowBox[{"[", "2", "]"}], "]"}]}], "&"}], ",", 
        RowBox[{"Subsets", "[", 
         RowBox[{
          RowBox[{"Range", "[", "l", "]"}], ",", 
          RowBox[{"{", "2", "}"}]}], "]"}]}], "]"}]}], "}"}], ",", 
    RowBox[{"Subsets", "[", 
     RowBox[{"edges", ",", 
      RowBox[{"Binomial", "[", 
       RowBox[{"l", ",", "2"}], "]"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7380691950257344`*^9, 3.7380694316040134`*^9}, {
   3.7380695751507397`*^9, 3.7380696090415115`*^9}, {3.7381507115331016`*^9, 
   3.738150728732603*^9}, {3.7381509198298626`*^9, 3.738150921289236*^9}, {
   3.7382201687402315`*^9, 3.738220187833954*^9}, {3.7382202499120045`*^9, 
   3.7382202539277215`*^9}, 3.738301214238596*^9, {3.73831193559335*^9, 
   3.738311953524679*^9}},
 CellLabel->"In[15]:=",ExpressionUUID->"19fd3c61-91c4-488c-9b0e-5807014e7e26"],

Cell[BoxData[
 RowBox[{
  RowBox[{"canonicalEdgeList", "[", "edgeList_", "]"}], ":=", 
  RowBox[{"EdgeList", "[", 
   RowBox[{"CanonicalGraph", "[", 
    RowBox[{"Graph", "[", "edgeList", "]"}], "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7380694900258884`*^9, 3.7380695096821337`*^9}, {
  3.738069657385244*^9, 3.738069662432133*^9}},
 CellLabel->"In[16]:=",ExpressionUUID->"0cf839c0-e1d1-45b7-9a50-d360ff8dc928"],

Cell[BoxData[
 RowBox[{
  RowBox[{"generateCensusGraphs", "[", "l_", "]"}], ":=", 
  RowBox[{"DeleteDuplicates", "[", 
   RowBox[{"Map", "[", 
    RowBox[{"canonicalEdgeList", ",", 
     RowBox[{"edgeListPermutations", "[", "l", "]"}]}], "]"}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.7380694384946413`*^9, 3.7380694858696346`*^9}, {
  3.738069520822769*^9, 3.7380695415258884`*^9}, {3.7380696655415044`*^9, 
  3.7380696662758837`*^9}, {3.738070061149367*^9, 3.738070061555623*^9}, {
  3.7381513940696545`*^9, 3.7381514322345285`*^9}, {3.7381516614545183`*^9, 
  3.738151664474519*^9}, {3.738311959153452*^9, 3.738311959325199*^9}, {
  3.738388177579053*^9, 3.7383881822839537`*^9}},
 CellLabel->"In[17]:=",ExpressionUUID->"ee221449-759a-4a8c-969d-c4dc9013f75a"],

Cell[BoxData[
 RowBox[{
  RowBox[{"automorphismCount", "[", 
   RowBox[{"n_", ",", "edgeList_"}], "]"}], ":=", 
  RowBox[{
   RowBox[{"n", "!"}], "/", 
   RowBox[{"GroupOrder", "[", 
    RowBox[{"GraphAutomorphismGroup", "[", 
     RowBox[{"Graph", "[", 
      RowBox[{
       RowBox[{"Range", "[", "n", "]"}], ",", "edgeList"}], "]"}], "]"}], 
    "]"}]}]}]], "Input",
 CellChangeTimes->{{3.7368442391917715`*^9, 3.736844364608551*^9}, {
  3.73684957377534*^9, 3.736849574061346*^9}, {3.7380698316352577`*^9, 
  3.7380698592133837`*^9}, {3.7380699976493692`*^9, 3.7380700023837414`*^9}},
 CellLabel->"In[18]:=",ExpressionUUID->"bf93e6cf-73d4-4aea-933d-fcaa9367e6d5"],

Cell[BoxData[
 RowBox[{
  RowBox[{"countCensusGraphs", "[", 
   RowBox[{"l_", ",", "n_", ",", "edgeList_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"adjacencyMatrix", "=", 
       RowBox[{"AdjacencyMatrix", "[", 
        RowBox[{"Graph", "[", 
         RowBox[{
          RowBox[{"Range", "[", "n", "]"}], ",", "edgeList"}], "]"}], "]"}]}],
       ",", 
      RowBox[{"variableList", "=", 
       RowBox[{"Map", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"Symbol", "[", 
           RowBox[{"\"\<i\>\"", "<>", 
            RowBox[{"ToString", "[", "#", "]"}]}], "]"}], "&"}], ",", 
         RowBox[{"Range", "[", "l", "]"}]}], "]"}]}], ",", 
      RowBox[{"keyMap", "=", 
       RowBox[{"Association", "[", 
        RowBox[{"Map", "[", 
         RowBox[{
          RowBox[{
           RowBox[{
            RowBox[{"PadLeft", "[", 
             RowBox[{
              RowBox[{"Sort", "[", 
               RowBox[{"VertexDegree", "[", "#", "]"}], "]"}], ",", "l"}], 
             "]"}], "\[Rule]", "#"}], "&"}], ",", 
          RowBox[{"generateCensusGraphs", "[", "l", "]"}]}], "]"}], "]"}]}]}],
      "}"}], ",", 
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"iteratorSequence", "=", 
        RowBox[{"Replace", "[", 
         RowBox[{
          RowBox[{"Map", "[", 
           RowBox[{
            RowBox[{
             RowBox[{"{", 
              RowBox[{
               RowBox[{"variableList", "[", 
                RowBox[{"[", "#", "]"}], "]"}], ",", 
               RowBox[{
                RowBox[{
                 RowBox[{"Join", "[", 
                  RowBox[{
                   RowBox[{"{", "0", "}"}], ",", "variableList"}], "]"}], "[", 
                 RowBox[{"[", "#", "]"}], "]"}], "+", "1"}], ",", 
               RowBox[{"n", "-", "l", "+", "#"}]}], "}"}], "&"}], ",", 
            RowBox[{"Range", "[", "l", "]"}]}], "]"}], ",", 
          RowBox[{
           RowBox[{"head_", "[", "arg__", "]"}], "\[RuleDelayed]", 
           RowBox[{"Sequence", "[", "arg", "]"}]}]}], "]"}]}], "}"}], ",", 
      RowBox[{"Module", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"counts", "=", 
          RowBox[{"Association", "[", 
           RowBox[{"Map", "[", 
            RowBox[{
             RowBox[{
              RowBox[{
               RowBox[{"PadLeft", "[", 
                RowBox[{
                 RowBox[{"Sort", "[", 
                  RowBox[{"VertexDegree", "[", "#", "]"}], "]"}], ",", "l"}], 
                "]"}], "->", "0"}], "&"}], ",", 
             RowBox[{"generateCensusGraphs", "[", "l", "]"}]}], "]"}], 
           "]"}]}], "}"}], ",", 
        RowBox[{
         RowBox[{"Do", "[", 
          RowBox[{
           RowBox[{
            RowBox[{"counts", "[", 
             RowBox[{"Sort", "[", 
              RowBox[{"Total", "[", 
               RowBox[{"adjacencyMatrix", "[", 
                RowBox[{"[", 
                 RowBox[{"variableList", ",", "variableList"}], "]"}], "]"}], 
               "]"}], "]"}], "]"}], "++"}], ",", "iteratorSequence"}], "]"}], 
         ";", 
         RowBox[{"counts", "=", 
          RowBox[{"KeyMap", "[", 
           RowBox[{"keyMap", ",", "counts"}], "]"}]}], ";", "counts"}]}], 
       "]"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.733718225046564*^9, 3.7337182685316153`*^9}, {
   3.733718306742591*^9, 3.7337185254918365`*^9}, {3.7337185719394064`*^9, 
   3.7337186260584354`*^9}, 3.733719992559498*^9, 3.733720442980399*^9, 
   3.7337204967894154`*^9, {3.7337205744364367`*^9, 3.7337206026844482`*^9}, 
   3.7337206582524676`*^9, {3.7337207218355055`*^9, 3.7337207402194924`*^9}, {
   3.7337217152630215`*^9, 3.733721718502021*^9}, {3.7337217789680653`*^9, 
   3.7337218173022056`*^9}, {3.733721911966092*^9, 3.733722023102254*^9}, {
   3.7337221205813713`*^9, 3.7337221452373433`*^9}, {3.7337222620933805`*^9, 
   3.7337224223154316`*^9}, {3.7337225872364864`*^9, 3.733722588259486*^9}, {
   3.7337241656525073`*^9, 3.733724184339546*^9}, {3.7337242527385693`*^9, 
   3.733724263595565*^9}, {3.7337246249636526`*^9, 3.733724632305674*^9}, {
   3.7337246714906673`*^9, 3.733724671920701*^9}, {3.733725177976241*^9, 
   3.7337252634722624`*^9}, 3.73527748451897*^9, {3.735277521129609*^9, 
   3.735277534041196*^9}, {3.7364954643193407`*^9, 3.736495467585436*^9}, {
   3.736846068355248*^9, 3.736846071683242*^9}, {3.7368510812282305`*^9, 
   3.736851096807667*^9}, {3.736853427145297*^9, 3.7368534298477154`*^9}, {
   3.737307687670416*^9, 3.7373076896235423`*^9}, 3.737308701739131*^9, 
   3.7373890579408307`*^9, {3.738300447392008*^9, 3.7383004556911464`*^9}, {
   3.7383004870278234`*^9, 3.738300516787038*^9}, 3.7383005634038906`*^9, {
   3.738314654595947*^9, 3.7383146589292855`*^9}, {3.738314787842755*^9, 
   3.7383148132327614`*^9}, {3.7383150723243427`*^9, 3.73831511515143*^9}, {
   3.738315152464489*^9, 3.7383151942148895`*^9}, {3.7383153392953196`*^9, 
   3.738315383447273*^9}, {3.7383154670076466`*^9, 3.7383154764389505`*^9}, {
   3.7383169869951935`*^9, 3.7383170757903514`*^9}, 3.7383171168621345`*^9, {
   3.7383171548620367`*^9, 3.738317167760306*^9}, {3.7383881913794527`*^9, 
   3.7383881913794527`*^9}, 3.7383882916671524`*^9, {3.7385675546846476`*^9, 
   3.738567559106388*^9}, {3.738569225897242*^9, 3.7385692284752054`*^9}},
 CellLabel->"In[19]:=",ExpressionUUID->"01f25ab2-cf78-400f-aefe-3bf47aac9f64"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Derived Input", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.7347688028302975`*^9}, {
   3.7381393890128098`*^9, 3.7381393929282093`*^9}, {3.7381394624870195`*^9, 
   3.7381394635180817`*^9}, 3.7383877578617897`*^9, {3.7383890747681756`*^9, 
   3.7383890749556756`*^9}, {3.738568081697937*^9, 
   3.7385680829479475`*^9}},ExpressionUUID->"5e1e88dc-b8aa-4255-8f78-\
beda3b1ebdd9"],

Cell["\<\
The total number of census types can be derived from the function which \
generates these types for each size.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7395957591429095`*^9, 3.7395957852365103`*^9}, {3.7396125776842318`*^9, 
  3.7396125799811*^9}},ExpressionUUID->"77a31e39-a4d9-458b-ac89-b3e134b00645"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusGraphCounts", "=", 
   RowBox[{"AssociationMap", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"Length", "[", 
       RowBox[{"generateCensusGraphs", "[", "#", "]"}], "]"}], "&"}], ",", 
     "censusSizes"}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.7353668188503513`*^9, 3.7353668271847153`*^9}, 
   3.7381393565126*^9, {3.7383879518281517`*^9, 3.7383879519345913`*^9}, {
   3.7385631355815754`*^9, 3.7385631365971746`*^9}, 3.738568089057165*^9},
 CellLabel->"In[20]:=",ExpressionUUID->"a4ef233b-722c-45c8-94c1-68f08b690569"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Examples", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.7347688028302975`*^9}, {
   3.7381393890128098`*^9, 3.7381393929282093`*^9}, 3.738387759252408*^9, {
   3.738389076189915*^9, 3.7383890765650454`*^9}, {3.738568052963565*^9, 
   3.7385680601354327`*^9}, 
   3.739615429366867*^9},ExpressionUUID->"bc01f1c9-54e1-46fd-b30f-\
c8500beaf26c"],

Cell["\<\
The following example shows the census types for each census size.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.739595788971024*^9, 
  3.7395958097678947`*^9}},ExpressionUUID->"30598fb6-1fc7-4583-b5d9-\
e224ab231c1b"],

Cell[BoxData[
 RowBox[{"DynamicModule", "[", 
  RowBox[{
   RowBox[{"{", "figureList", "}"}], ",", 
   RowBox[{"Manipulate", "[", 
    RowBox[{
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"graphs", "=", 
         RowBox[{"generateCensusGraphs", "[", "l", "]"}]}], "}"}], ",", 
       RowBox[{"Grid", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{"\"\<Census count: \>\"", ",", 
             RowBox[{"censusGraphCounts", "[", "l", "]"}]}], "}"}], ",", 
           RowBox[{"Join", "[", 
            RowBox[{
             RowBox[{"{", "\"\<Census graphs: \>\"", "}"}], ",", 
             RowBox[{"figureList", "=", 
              RowBox[{"Map", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"Graph", "[", 
                  RowBox[{
                   RowBox[{"Range", "[", "l", "]"}], ",", "#", ",", 
                   RowBox[{
                   "GraphLayout", "\[Rule]", "\"\<CircularEmbedding\>\""}], 
                   ",", 
                   RowBox[{"ImagePadding", "\[Rule]", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"8", ",", "8"}], "}"}], ",", 
                    RowBox[{"{", 
                    RowBox[{"2", ",", "8"}], "}"}]}], "}"}]}], ",", 
                   RowBox[{"ImageSize", "\[Rule]", "100"}]}], "]"}], "&"}], 
                ",", "graphs"}], "]"}]}]}], "]"}], ",", 
           RowBox[{"Join", "[", 
            RowBox[{
             RowBox[{"{", "\"\<Automorphism count: \>\"", "}"}], ",", 
             RowBox[{"Map", "[", 
              RowBox[{
               RowBox[{
                RowBox[{"automorphismCount", "[", 
                 RowBox[{"l", ",", "#"}], "]"}], "&"}], ",", "graphs"}], 
              "]"}]}], "]"}]}], "}"}], ",", 
         RowBox[{"Spacings", "\[Rule]", 
          RowBox[{"{", 
           RowBox[{"2", ",", "2"}], "}"}]}]}], "]"}]}], "]"}], ",", 
     RowBox[{"Grid", "[", 
      RowBox[{"{", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"Control", "[", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{"l", ",", "3", ",", "\"\<Subgraph size\>\""}], "}"}], 
            ",", "censusSizes"}], "}"}], "]"}], ",", 
         RowBox[{"Button", "[", 
          RowBox[{"\"\<Export Figure 3\>\"", ",", 
           RowBox[{"Do", "[", 
            RowBox[{
             RowBox[{
              RowBox[{"Export", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"ToString", "[", 
                  RowBox[{"NotebookDirectory", "[", "]"}], "]"}], "<>", 
                 "\"\<\\\\Figure03_\>\"", "<>", 
                 RowBox[{"ToString", "[", "i", "]"}], "<>", "\"\<.pdf\>\""}], 
                ",", 
                RowBox[{"figureList", "[", 
                 RowBox[{"[", "i", "]"}], "]"}]}], "]"}], ";"}], ",", 
             RowBox[{"{", 
              RowBox[{"i", ",", "1", ",", 
               RowBox[{"Length", "[", "figureList", "]"}]}], "}"}]}], "]"}]}],
           "]"}]}], "}"}], "}"}], "]"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.7354596518738437`*^9, 3.735459784233262*^9}, {
   3.735459971920841*^9, 3.735460076780085*^9}, {3.7354601775146446`*^9, 
   3.735460282577188*^9}, {3.7354603129051695`*^9, 3.735460313905306*^9}, {
   3.7354603591240873`*^9, 3.735460417388708*^9}, {3.735461052593459*^9, 
   3.735461062702982*^9}, {3.7354615385339246`*^9, 3.7354615440495424`*^9}, {
   3.73546246563865*^9, 3.735462552047614*^9}, 3.7354626565981326`*^9, {
   3.7357360174118237`*^9, 3.7357360367243166`*^9}, {3.736052041568481*^9, 
   3.736052045190166*^9}, {3.736052800983588*^9, 3.7360528118874316`*^9}, {
   3.736052875272599*^9, 3.736052945023676*^9}, {3.7360530199841805`*^9, 
   3.73605313143056*^9}, {3.7360531704751186`*^9, 3.736053174014703*^9}, {
   3.7360537600248337`*^9, 3.7360537773128777`*^9}, 3.736053855217415*^9, {
   3.7360719928505154`*^9, 3.736072044745329*^9}, {3.736072105571279*^9, 
   3.7360721909321404`*^9}, {3.73649498624448*^9, 3.7364949871193457`*^9}, {
   3.7368400888834076`*^9, 3.736840293737591*^9}, {3.7368403530673585`*^9, 
   3.7368403564562907`*^9}, {3.7368404103362427`*^9, 
   3.7368404115707283`*^9}, {3.7368406150780387`*^9, 
   3.7368407102708073`*^9}, {3.7368419286014285`*^9, 
   3.7368419531858444`*^9}, {3.736841984452301*^9, 3.736842011083294*^9}, {
   3.7368495903943405`*^9, 3.7368496363993454`*^9}, {3.738069786150733*^9, 
   3.7380698257915087`*^9}, {3.7380698618852634`*^9, 3.738069862119646*^9}, {
   3.738070029664983*^9, 3.7380700313210993`*^9}, 3.738079641557477*^9, 
   3.7380797112137303`*^9, {3.7380802189793453`*^9, 3.7380802881510863`*^9}, 
   3.7381393565176015`*^9, {3.7381516375995617`*^9, 3.7381516423245306`*^9}, {
   3.738151699969576*^9, 3.738151700514658*^9}, 3.7382203962107334`*^9, {
   3.7382204296794844`*^9, 3.73822049511896*^9}, 3.7383881913638325`*^9, 
   3.7383882583999953`*^9},
 CellLabel->"In[21]:=",ExpressionUUID->"caaf14cd-fc0c-48cf-b2e5-18646fd8c426"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Metropolis-Hastings Sampling", "Section",
 CellChangeTimes->{{3.7311485456128216`*^9, 3.731148566553211*^9}, {
  3.7311728763702154`*^9, 3.731172876585377*^9}, {3.734767021695509*^9, 
  3.734767028429741*^9}, {3.7383888227251654`*^9, 
  3.738388839628624*^9}},ExpressionUUID->"6b64f766-2d6f-4b53-b40b-\
fa2c6dfc2ff6"],

Cell["\<\
In the \[OpenCurlyDoubleQuote]Parameter Estimation\[CloseCurlyDoubleQuote] \
section, the likelihood function of a model is determined based on the \
observed data. An easy way to work with likelihood functions is to sample \
from them using the Metropolis-Hastings algorithm. This algorithm is \
implemented in the current section.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.739594366581928*^9, 3.739594467988177*^9}, {3.7396107012458525`*^9, 
  3.739610773408927*^9}, {3.7396110712279973`*^9, 
  3.7396110717592516`*^9}},ExpressionUUID->"eb9a74f9-b6ef-429d-ae83-\
92fb89967539"],

Cell[CellGroupData[{

Cell["Functions", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.7347670461329994`*^9, 3.7347670481955194`*^9}, 
   3.738071683632786*^9, 3.7382206816658645`*^9, {3.7382207653378468`*^9, 
   3.738220765525205*^9}, {3.7383888446286244`*^9, 3.7383888448785963`*^9}, {
   3.738389054001356*^9, 
   3.738389054219966*^9}},ExpressionUUID->"6fa987bc-30f7-47da-9025-\
5c67c6e34962"],

Cell["\<\
The Metropolis-Hastings algorithm is a fairly simple algorithm, described in \
more detail elsewhere [13]. The implementation below takes as arguments the \
likelihood function, starting value(s), a distribution which influences the \
random walk, the number of iterations and the number of iterations to throw \
away from the start.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
   3.7395944746131835`*^9, 3.739594633816195*^9}, 3.7395965173096876`*^9, 
   3.739610876300728*^9},ExpressionUUID->"1572f5a2-6dc0-4d52-a2b8-\
6c3ac30dff2a"],

Cell[BoxData[
 RowBox[{
  RowBox[{"metropolisHastings", "[", 
   RowBox[{
   "function_", ",", "start_", ",", "distribution_", ",", "iterations_", ",", 
    "burnin_"}], "]"}], ":=", 
  RowBox[{"Quiet", "[", 
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"previous", "=", "start"}], ",", "proposal"}], "}"}], ",", 
     RowBox[{
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"proposal", "=", 
          RowBox[{"Map", "[", 
           RowBox[{
            RowBox[{
             RowBox[{"RandomVariate", "[", 
              RowBox[{"distribution", "[", "#", "]"}], "]"}], "&"}], ",", 
            "previous"}], "]"}]}], ";", 
         RowBox[{"If", "[", 
          RowBox[{
           RowBox[{
            RowBox[{"function", "[", "proposal", "]"}], ">", 
            RowBox[{
             RowBox[{"RandomReal", "[", "]"}], " ", 
             RowBox[{"function", "[", "previous", "]"}]}]}], ",", 
           RowBox[{"previous", "=", "proposal"}], ",", "previous"}], "]"}]}], 
        ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", "1", ",", "iterations"}], "}"}]}], "]"}], "[", 
      RowBox[{"[", 
       RowBox[{
        RowBox[{"1", "+", "burnin"}], ";;", 
        RowBox[{"-", "1"}]}], "]"}], "]"}]}], "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7387723250667706`*^9, 3.7387723250697684`*^9}, {
   3.7387726384792643`*^9, 3.738772795228593*^9}, {3.738773089484309*^9, 
   3.73877310649646*^9}, {3.738773161148459*^9, 3.738773185362462*^9}, {
   3.7387732338844957`*^9, 3.73877323470251*^9}, 3.738773371290247*^9, {
   3.7387734229352193`*^9, 3.7387734232762156`*^9}, 3.738773596161359*^9, {
   3.739283621596944*^9, 3.739283626427062*^9}},
 CellLabel->"In[22]:=",ExpressionUUID->"c4d3a3ce-d908-4d7f-b383-eab392505c7e"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Visualisation Functions", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7353639674740095`*^9, {3.736572676118946*^9, 3.736572678040842*^9}, {
   3.7377170173360643`*^9, 3.737717024273598*^9}, {3.738220891759717*^9, 
   3.73822089227536*^9}, 
   3.738389056501348*^9},ExpressionUUID->"d7c43cd8-48d9-4aa2-ba08-\
eb69222275a4"],

Cell["\<\
The following function helps visualise some metrics about the sample taken \
from the distribution.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.739594641144431*^9, 3.7395946798005342`*^9}, {3.7396111043488803`*^9, 
  3.739611105505028*^9}, {3.7396126376743784`*^9, 
  3.7396126387525053`*^9}},ExpressionUUID->"4b21881d-c88a-44d4-9dec-\
0a736a481564"],

Cell[BoxData[
 RowBox[{
  RowBox[{"samplingDescription", "[", "list_", "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"mean", "=", 
       RowBox[{"Mean", "[", "list", "]"}]}], ",", 
      RowBox[{"standardDeviation", "=", 
       RowBox[{"StandardDeviation", "[", "list", "]"}]}]}], "}"}], ",", 
    RowBox[{"Grid", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"Join", "[", 
         RowBox[{
          RowBox[{"{", "\"\<\>\"", "}"}], ",", 
          RowBox[{"Map", "[", 
           RowBox[{
            RowBox[{
             RowBox[{"\"\<p\>\"", "<>", 
              RowBox[{"ToString", "[", "#", "]"}]}], "&"}], ",", 
            RowBox[{"Range", "[", 
             RowBox[{"Length", "[", "mean", "]"}], "]"}]}], "]"}]}], "]"}], 
        ",", 
        RowBox[{"Join", "[", 
         RowBox[{
          RowBox[{"{", "\"\<Mean\>\"", "}"}], ",", " ", 
          RowBox[{"N", "[", "mean", "]"}]}], "]"}], ",", 
        RowBox[{"Join", "[", 
         RowBox[{
          RowBox[{"{", "\"\<Std\>\"", "}"}], ",", 
          RowBox[{"N", "[", "standardDeviation", "]"}]}], "]"}], ",", 
        RowBox[{"Join", "[", 
         RowBox[{
          RowBox[{"{", "\"\<Median\>\"", "}"}], ",", 
          RowBox[{"N", "[", 
           RowBox[{"Median", "[", "list", "]"}], "]"}]}], "]"}], ",", 
        RowBox[{"Join", "[", 
         RowBox[{
          RowBox[{"{", "\"\<Quantiles(0.9,0.95)\>\"", "}"}], ",", 
          RowBox[{"Map", "[", 
           RowBox[{
            RowBox[{
             RowBox[{"Row", "[", 
              RowBox[{"#", ",", "\"\< \>\""}], "]"}], "&"}], ",", 
            RowBox[{"N", "[", 
             RowBox[{"Quantile", "[", 
              RowBox[{"list", ",", 
               RowBox[{"{", 
                RowBox[{"0.025", ",", "0.05", ",", "0.95", ",", "0.975"}], 
                "}"}]}], "]"}], "]"}]}], "]"}]}], "]"}], ",", 
        RowBox[{"Join", "[", 
         RowBox[{
          RowBox[{"{", "\"\<2\[Sigma] intervals\>\"", "}"}], ",", 
          RowBox[{"MapThread", "[", 
           RowBox[{
            RowBox[{
             RowBox[{"Row", "[", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"#1", "-", 
                  RowBox[{"2", "#2"}]}], ",", 
                 RowBox[{"#1", "+", 
                  RowBox[{"2", "#2"}]}]}], "}"}], ",", "\"\< \>\""}], "]"}], 
             "&"}], ",", 
            RowBox[{"{", 
             RowBox[{"mean", ",", "standardDeviation"}], "}"}]}], "]"}]}], 
         "]"}]}], "}"}], ",", 
      RowBox[{"Spacings", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"1", ",", "1"}], "}"}]}], ",", 
      RowBox[{"Dividers", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{"False", ",", "True"}], "}"}], ",", 
         RowBox[{"{", 
          RowBox[{"False", ",", "True"}], "}"}]}], "}"}]}]}], "]"}]}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.7344341678097897`*^9, 3.7344343027004447`*^9}, {
   3.734674457936862*^9, 3.734674458874365*^9}, {3.7347684406113453`*^9, 
   3.7347684924708543`*^9}, {3.73476868903327*^9, 3.734768704064523*^9}, 
   3.736495259534771*^9, {3.736495314224171*^9, 3.736495319817871*^9}, {
   3.7364954082165337`*^9, 3.736495418207209*^9}, 3.7380714382732573`*^9, {
   3.738299825415004*^9, 3.738299887447156*^9}, {3.738299924552644*^9, 
   3.7383000490313296`*^9}, {3.7383000807544627`*^9, 3.738300156047098*^9}, {
   3.739252295592535*^9, 3.7392523347801294`*^9}, {3.7392525244518623`*^9, 
   3.7392525486082463`*^9}, {3.739254641430626*^9, 3.739254754274511*^9}, {
   3.7392547901493897`*^9, 3.739254812524497*^9}, {3.739281513989251*^9, 
   3.7392815500192404`*^9}, {3.7395935931180754`*^9, 3.739593626640735*^9}},
 CellLabel->"In[23]:=",ExpressionUUID->"fffb1614-bf7c-4e98-be99-4371790c202e"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Examples", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.7347670507736425`*^9, 3.7347670521017723`*^9}, {
   3.7380717546952724`*^9, 3.738071756648403*^9}, 3.7380718077421484`*^9, {
   3.738389063298228*^9, 
   3.738389064392009*^9}},ExpressionUUID->"0adcd58b-aab2-490a-a6ac-\
6cb68724e650"],

Cell["\<\
The examples in this subsection compare the results of the \
Metropolis-Hastings algorithm for some standard distributions with a more \
direct sampling technique.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.73959468808193*^9, 3.739594706628828*^9}, {3.7395947414001303`*^9, 
  3.7395947953487663`*^9}},ExpressionUUID->"473a5bee-2143-4645-9e02-\
8d00131556fa"],

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"sampling", "=", 
     RowBox[{"RandomVariate", "[", 
      RowBox[{
       RowBox[{"MultinormalDistribution", "[", 
        RowBox[{
         RowBox[{"{", "0", "}"}], ",", 
         RowBox[{"{", 
          RowBox[{"{", "1", "}"}], "}"}]}], "]"}], ",", "10000"}], "]"}]}], 
    "}"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Column", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"samplingDescription", "[", "sampling", "]"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"Row", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
              RowBox[{"Histogram", "[", 
               RowBox[{
                RowBox[{"Flatten", "[", "sampling", "]"}], ",", "30", ",", 
                "\"\<PDF\>\""}], "]"}], ",", 
              RowBox[{"Plot", "[", 
               RowBox[{
                RowBox[{"PDF", "[", 
                 RowBox[{
                  RowBox[{"NormalDistribution", "[", 
                   RowBox[{"0", ",", "1"}], "]"}], ",", "x"}], "]"}], ",", 
                RowBox[{"{", 
                 RowBox[{"x", ",", 
                  RowBox[{"-", "2"}], ",", "2"}], "}"}]}], "]"}]}], "}"}], 
            ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.4"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}], ",", 
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"SmoothHistogram", "[", 
             RowBox[{"Flatten", "[", "sampling", "]"}], "]"}], ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.4"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}], "}"}], 
        "]"}]}], "}"}], ",", 
     RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.734673953040533*^9, 3.73467411479071*^9}, {
  3.7346741869782324`*^9, 3.7346743585149574`*^9}, {3.7346744658743734`*^9, 
  3.734674469327511*^9}, {3.734674632379953*^9, 3.7346746343175993`*^9}, {
  3.734674665911354*^9, 3.7346746830049667`*^9}, {3.7346750866458273`*^9, 
  3.7346751003645844`*^9}, {3.7347670792762814`*^9, 3.7347671173122764`*^9}, {
  3.7354482025735254`*^9, 3.7354482071138773`*^9}, {3.735449502914421*^9, 
  3.735449503129835*^9}, {3.7364952591012926`*^9, 3.736495284776021*^9}, {
  3.7382996094700317`*^9, 3.7382996376600885`*^9}, {3.7382996754380174`*^9, 
  3.7382996786704917`*^9}, {3.7392522178895035`*^9, 3.739252269279992*^9}, {
  3.739252338108158*^9, 3.739252363686369*^9}},
 CellLabel->"In[24]:=",ExpressionUUID->"ef3c24bf-4cad-486c-9b3c-c2892df9ade1"],

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"sampling", "=", 
     RowBox[{"metropolisHastings", "[", 
      RowBox[{
       RowBox[{"PDF", "[", 
        RowBox[{"MultinormalDistribution", "[", 
         RowBox[{
          RowBox[{"{", "0", "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"{", "1", "}"}], "}"}]}], "]"}], "]"}], ",", 
       RowBox[{"{", "0", "}"}], ",", 
       RowBox[{"Function", "[", 
        RowBox[{
         RowBox[{"{", "x", "}"}], ",", 
         RowBox[{"NormalDistribution", "[", 
          RowBox[{"x", ",", "0.3"}], "]"}]}], "]"}], ",", "10000", ",", "0"}],
       "]"}]}], "}"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Column", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"samplingDescription", "[", "sampling", "]"}], ",", 
       RowBox[{"Row", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
              RowBox[{"Histogram", "[", 
               RowBox[{
                RowBox[{"Flatten", "[", "sampling", "]"}], ",", "30", ",", 
                "\"\<PDF\>\""}], "]"}], ",", 
              RowBox[{"Plot", "[", 
               RowBox[{
                RowBox[{"PDF", "[", 
                 RowBox[{
                  RowBox[{"NormalDistribution", "[", 
                   RowBox[{"0", ",", "1"}], "]"}], ",", "x"}], "]"}], ",", 
                RowBox[{"{", 
                 RowBox[{"x", ",", 
                  RowBox[{"-", "2"}], ",", "2"}], "}"}]}], "]"}]}], "}"}], 
            ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.4"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}], ",", 
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"SmoothHistogram", "[", 
             RowBox[{"Flatten", "[", "sampling", "]"}], "]"}], ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.4"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}], "}"}], 
        "]"}]}], "}"}], ",", 
     RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.734674373577482*^9, 3.7346744742806077`*^9}, {
   3.7346745842912025`*^9, 3.734674618181972*^9}, {3.7346746693800964`*^9, 
   3.7346747023957405`*^9}, {3.73467476684888*^9, 3.734674784379996*^9}, {
   3.7346748210520053`*^9, 3.734674821411394*^9}, {3.734674860177026*^9, 
   3.734674891473765*^9}, {3.7346749590831547`*^9, 3.7346749847862873`*^9}, {
   3.734675114927075*^9, 3.7346751500988255`*^9}, {3.734675183052894*^9, 
   3.734675193381015*^9}, {3.734767102671683*^9, 3.7347671130780454`*^9}, {
   3.734768034460701*^9, 3.7347680349920964`*^9}, {3.734768545486395*^9, 
   3.7347685482677383`*^9}, {3.7347686189239035`*^9, 
   3.7347686267990108`*^9}, {3.735042235382596*^9, 3.7350422680076647`*^9}, {
   3.735042298900191*^9, 3.735042329674783*^9}, 3.7350425196281137`*^9, {
   3.7350434862235346`*^9, 3.735043488834121*^9}, {3.7350643352521467`*^9, 
   3.735064387033258*^9}, {3.7354468781806087`*^9, 3.7354469074807453`*^9}, {
   3.735447029896304*^9, 3.7354470515811715`*^9}, {3.735447086380553*^9, 
   3.735447087480936*^9}, {3.7354471288978195`*^9, 3.735447163299759*^9}, {
   3.7354482161975365`*^9, 3.7354482197467957`*^9}, {3.7354494998138127`*^9, 
   3.7354495000807905`*^9}, {3.7364952591012926`*^9, 3.7364952663665867`*^9}, 
   3.7387733270613365`*^9, 3.739252141529993*^9, {3.7392524755456104`*^9, 
   3.739252509342634*^9}, 3.7392814189295907`*^9, {3.739281571599578*^9, 
   3.7392815735195074`*^9}},
 CellLabel->"In[25]:=",ExpressionUUID->"90865b3e-5949-4057-9f9a-35901ebd95e5"],

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"sampling", "=", 
     RowBox[{"RandomVariate", "[", 
      RowBox[{
       RowBox[{"MultinormalDistribution", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{"0", ",", "0"}], "}"}], ",", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{"1", ",", "0"}], "}"}], ",", 
           RowBox[{"{", 
            RowBox[{"0", ",", "1"}], "}"}]}], "}"}]}], "]"}], ",", "10000"}], 
      "]"}]}], "}"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Column", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"samplingDescription", "[", "sampling", "]"}], ",", 
       RowBox[{"Row", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"Histogram3D", "[", 
             RowBox[{"sampling", ",", "30", ",", "\"\<PDF\>\""}], "]"}], ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.16"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}], ",", 
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"SmoothHistogram3D", "[", "sampling", "]"}], ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.16"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}], "}"}], 
        "]"}]}], "}"}], ",", 
     RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.734673953040533*^9, 3.73467411479071*^9}, {
   3.7346741869782324`*^9, 3.7346743585149574`*^9}, {3.7346744658743734`*^9, 
   3.734674469327511*^9}, {3.734674632379953*^9, 3.7346746343175993`*^9}, {
   3.734674665911354*^9, 3.7346746830049667`*^9}, {3.7347671581248565`*^9, 
   3.7347671880154257`*^9}, {3.7364952591012926`*^9, 3.7364952820728965`*^9}, 
   3.739252110842622*^9, {3.739252152623784*^9, 3.739252163436384*^9}, {
   3.739252569936244*^9, 3.73925259043637*^9}, 3.739281421159201*^9, {
   3.739281593862121*^9, 3.739281596839447*^9}},
 CellLabel->"In[26]:=",ExpressionUUID->"d6ebdd83-b966-4d44-a03b-58adfbe1bf19"],

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"sampling", "=", 
     RowBox[{"metropolisHastings", "[", 
      RowBox[{
       RowBox[{"PDF", "[", 
        RowBox[{"MultinormalDistribution", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"0", ",", "0"}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{"1", ",", "0"}], "}"}], ",", 
            RowBox[{"{", 
             RowBox[{"0", ",", "1"}], "}"}]}], "}"}]}], "]"}], "]"}], ",", 
       RowBox[{"{", 
        RowBox[{"0", ",", "0"}], "}"}], ",", 
       RowBox[{"Function", "[", 
        RowBox[{
         RowBox[{"{", "x", "}"}], ",", 
         RowBox[{"NormalDistribution", "[", 
          RowBox[{"x", ",", "0.3"}], "]"}]}], "]"}], ",", "10000", ",", "0"}],
       "]"}]}], "}"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Column", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"samplingDescription", "[", "sampling", "]"}], ",", 
       RowBox[{"Row", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"Histogram3D", "[", 
             RowBox[{"sampling", ",", "30", ",", "\"\<PDF\>\""}], "]"}], ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.16"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}], ",", 
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"SmoothHistogram3D", "[", "sampling", "]"}], ",", 
            RowBox[{"PlotRange", "->", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"-", "2"}], ",", "2"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"0", ",", "0.16"}], "}"}]}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}], "}"}], 
        "]"}]}], "}"}], ",", 
     RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.734674373577482*^9, 3.7346744742806077`*^9}, {
   3.7346745842912025`*^9, 3.734674618181972*^9}, {3.7346746693800964`*^9, 
   3.7346747023957405`*^9}, {3.73467476684888*^9, 3.734674784379996*^9}, {
   3.7346748210520053`*^9, 3.734674821411394*^9}, {3.734674860177026*^9, 
   3.734674891473765*^9}, {3.7346749590831547`*^9, 3.7346749847862873`*^9}, 
   3.7346752030997734`*^9, {3.7347671626405516`*^9, 3.7347671856249337`*^9}, {
   3.7347675844761877`*^9, 3.7347675846482115`*^9}, {3.7350642958656206`*^9, 
   3.7350643186895075`*^9}, {3.7354472162306013`*^9, 
   3.7354472195173492`*^9}, {3.7354479761305294`*^9, 
   3.7354479780957017`*^9}, {3.736495259116883*^9, 3.7364952663821836`*^9}, {
   3.739252167092491*^9, 3.7392521748582516`*^9}, {3.7392530150233774`*^9, 
   3.73925303817974*^9}, 3.739281423843454*^9},
 CellLabel->"In[27]:=",ExpressionUUID->"a990f015-7534-4d07-b31a-df2287d8ccd4"],

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"sampling", "=", 
     RowBox[{"RandomVariate", "[", 
      RowBox[{
       RowBox[{"BetaDistribution", "[", 
        RowBox[{"33", ",", "67"}], "]"}], ",", 
       RowBox[{"{", 
        RowBox[{"10000", ",", "1"}], "}"}]}], "]"}]}], "}"}], ",", 
   "\[IndentingNewLine]", 
   RowBox[{"Column", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"samplingDescription", "[", "sampling", "]"}], ",", 
       RowBox[{"Row", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
              RowBox[{"Histogram", "[", 
               RowBox[{
                RowBox[{"Flatten", "[", "sampling", "]"}], ",", "30", ",", 
                "\"\<PDF\>\""}], "]"}], ",", 
              RowBox[{"Plot", "[", 
               RowBox[{
                RowBox[{"PDF", "[", 
                 RowBox[{
                  RowBox[{"BetaDistribution", "[", 
                   RowBox[{"33", ",", "67"}], "]"}], ",", "x"}], "]"}], ",", 
                RowBox[{"{", 
                 RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                RowBox[{"PlotRange", "\[Rule]", "All"}]}], "]"}]}], "}"}], 
            ",", 
            RowBox[{"PlotRange", "\[Rule]", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"0", ",", "1"}], "}"}], ",", "All"}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}], ",", 
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"SmoothHistogram", "[", 
             RowBox[{"Flatten", "[", "sampling", "]"}], "]"}], ",", 
            RowBox[{"PlotRange", "\[Rule]", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"0", ",", "1"}], "}"}], ",", "All"}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}], "}"}], 
        "]"}]}], "}"}], ",", 
     RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.734673953040533*^9, 3.73467411479071*^9}, {
   3.7346741869782324`*^9, 3.7346743585149574`*^9}, {3.7346744658743734`*^9, 
   3.734674469327511*^9}, {3.734674632379953*^9, 3.7346746343175993`*^9}, {
   3.734674665911354*^9, 3.7346746830049667`*^9}, {3.7346750866458273`*^9, 
   3.7346751003645844`*^9}, {3.7347670792762814`*^9, 
   3.7347671173122764`*^9}, {3.735447368513906*^9, 3.7354473799975576`*^9}, {
   3.735448063364066*^9, 3.735448110447378*^9}, {3.7354493392645426`*^9, 
   3.7354493962526693`*^9}, 3.735449482564145*^9, {3.736495259116883*^9, 
   3.7364952820728965`*^9}, {3.7382996951700315`*^9, 3.738299717579254*^9}, {
   3.738299786727514*^9, 3.738299802740119*^9}, {3.739252182514493*^9, 
   3.7392521878581667`*^9}, {3.7392530627421727`*^9, 3.739253101804638*^9}, 
   3.7392814254192095`*^9},
 CellLabel->"In[28]:=",ExpressionUUID->"310d5584-fa8b-480c-ba73-0ab686b1a24b"],

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"sampling", "=", 
     RowBox[{"metropolisHastings", "[", 
      RowBox[{
       RowBox[{"Function", "[", 
        RowBox[{
         RowBox[{"{", "x", "}"}], ",", 
         RowBox[{"PDF", "[", 
          RowBox[{
           RowBox[{"BetaDistribution", "[", 
            RowBox[{"33", ",", "67"}], "]"}], ",", 
           RowBox[{"x", "[", 
            RowBox[{"[", "1", "]"}], "]"}]}], "]"}]}], "]"}], ",", 
       RowBox[{"{", "0.5", "}"}], ",", 
       RowBox[{"Function", "[", 
        RowBox[{
         RowBox[{"{", "x", "}"}], ",", 
         RowBox[{"BetaDistribution", "[", 
          RowBox[{
           RowBox[{
            RowBox[{"10", "^", 
             RowBox[{"-", "2"}]}], "+", 
            RowBox[{"100", "x"}]}], ",", 
           RowBox[{
            RowBox[{"10", "^", 
             RowBox[{"-", "2"}]}], "+", 
            RowBox[{"100", 
             RowBox[{"(", 
              RowBox[{"1", "-", "x"}], ")"}]}]}]}], "]"}]}], "]"}], ",", 
       "10000", ",", "0"}], "]"}]}], "}"}], ",", "\[IndentingNewLine]", 
   RowBox[{"Column", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"samplingDescription", "[", "sampling", "]"}], ",", 
       RowBox[{"Row", "[", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
              RowBox[{"Histogram", "[", 
               RowBox[{
                RowBox[{"Flatten", "[", "sampling", "]"}], ",", "30", ",", 
                "\"\<PDF\>\""}], "]"}], ",", 
              RowBox[{"Plot", "[", 
               RowBox[{
                RowBox[{"PDF", "[", 
                 RowBox[{
                  RowBox[{"BetaDistribution", "[", 
                   RowBox[{"33", ",", "67"}], "]"}], ",", "x"}], "]"}], ",", 
                RowBox[{"{", 
                 RowBox[{"x", ",", "0", ",", "1"}], "}"}], ",", 
                RowBox[{"PlotRange", "\[Rule]", "All"}]}], "]"}]}], "}"}], 
            ",", 
            RowBox[{"PlotRange", "\[Rule]", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"0", ",", "1"}], "}"}], ",", "All"}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}], ",", 
          RowBox[{"Show", "[", 
           RowBox[{
            RowBox[{"SmoothHistogram", "[", 
             RowBox[{"Flatten", "[", "sampling", "]"}], "]"}], ",", 
            RowBox[{"PlotRange", "\[Rule]", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"0", ",", "1"}], "}"}], ",", "All"}], "}"}]}], ",", 
            RowBox[{"ImageSize", "\[Rule]", "350"}]}], "]"}]}], "}"}], 
        "]"}]}], "}"}], ",", 
     RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.7354492365186844`*^9, 3.7354492453805876`*^9}, {
   3.735449282247225*^9, 3.735449313908244*^9}, {3.735449416656438*^9, 
   3.735449421164014*^9}, 3.7354494932318134`*^9, {3.736495259116883*^9, 
   3.7364952663821836`*^9}, 3.7387734974153214`*^9, {3.739252194045737*^9, 
   3.7392522006395006`*^9}, {3.7392531140390043`*^9, 3.7392531505391316`*^9}, 
   3.7392814273192806`*^9},
 CellLabel->"In[29]:=",ExpressionUUID->"a47af384-b280-4cea-bd2d-ddac1f4051ed"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Parameter Estimation", "Section",
 CellChangeTimes->{{3.7311485456128216`*^9, 3.731148566553211*^9}, {
  3.7311728763702154`*^9, 3.731172876585377*^9}, {3.7347687870178213`*^9, 
  3.7347687934239264`*^9}, {3.7382208364628296`*^9, 
  3.7382208367596884`*^9}},ExpressionUUID->"a67244df-8005-4608-a14c-\
56ecb05cccd7"],

Cell["\<\
The original articles describing SUGMs contain two methods to estimate the \
parameters of the model. The current work suggests a third, more intuitive \
method based on the subgraph census, which also takes overlap and incidental \
subgraph formation into account.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
   3.7362379532418528`*^9, 3.736237962911622*^9}, {3.736241601833735*^9, 
   3.7362416179015417`*^9}, {3.73685889075249*^9, 3.736858894825054*^9}, {
   3.7370868535684175`*^9, 3.737086858474531*^9}, {3.7395951166195107`*^9, 
   3.739595117322335*^9}, 3.7396034148427057`*^9, {3.739612654596259*^9, 
   3.7396126813956437`*^9}, {3.739615585288664*^9, 3.7396155856479807`*^9}, {
   3.739679662320471*^9, 
   3.73967966314859*^9}},ExpressionUUID->"386481d8-6253-42aa-ac36-\
1781ccafba7b"],

Cell[CellGroupData[{

Cell["Functions", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7313961390776787`*^9, {3.734768800377195*^9, 3.7347688028302975`*^9}, {
   3.738220658150346*^9, 3.738220659337759*^9}, 3.7382208421503677`*^9, 
   3.7383890804400525`*^9},ExpressionUUID->"a0a1012f-96e9-417d-878e-\
a6ade2b6d680"],

Cell[TextData[{
 "This subsection defines various functions relevant for estimating the model\
\[CloseCurlyQuote]s parameters. The ultimate goal is to define the correct \
likelihood function, which describes the distribution over the parameters \
depending on the observed data. The likelihood function is a combination of \
the census counts and the probability functions for the expected values for \
each census type. In general, each of the ",
 StyleBox["r",
  FontSlant->"Italic"],
 " counts of the census ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["x", "j"], TraditionalForm]],ExpressionUUID->
  "e8044385-4e5d-4198-8b23-0f6792bb991c"],
 ", together with the probability functions ",
 Cell[BoxData[
  FormBox[
   SubscriptBox["f", "j"], TraditionalForm]],ExpressionUUID->
  "cfe788fd-060a-40e6-8a7c-9696a094c776"],
 "(",
 Cell[BoxData[
  FormBox[
   SubscriptBox[
    OverscriptBox["p", "^"], "1"], TraditionalForm]],ExpressionUUID->
  "434d9f30-2ce1-42d9-ab35-2bbca8b84b98"],
 ",...,",
 Cell[BoxData[
  FormBox[
   SubscriptBox[
    OverscriptBox["p", "^"], "q"], TraditionalForm]],ExpressionUUID->
  "d26e9bd9-6bed-442e-8179-1cc08697053d"],
 "), enter into the multinomial probability mass function to form the \
likelihood function.\n\nWhen examining the probability functions, two \
patterns can be extracted. The first depends on the types of subgraphs \
contained in the model. The second depends on the size of the census. In this \
subsection, several functions are defined which generate permutations for \
subgraphs. To extract the first pattern, the permutations are used to \
determine in how many cases a subgraph can produce edges in a census \
subgraph. Then, the overlap of all permutations is used to determine the \
dependency on the census size. Combining both gives the probability functions \
and the likelihood functions for any model. These can be used to estimate the \
parameters of the model and their confidence intervals. The likelihood \
function also includes a degree-of-freedom compensator which approximately \
takes into account the correlations between generated edges.\n\nFinally, a \
function is defined which determines the Mahalanobis distance between the \
maximum likelihood estimates and the true parameters. This allows for the \
verification of the standard errors of the estimates and of the \
degree-of-freedom compensator."
}], "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.739600208045162*^9, 3.7396004026829014`*^9}, {3.7396034461615047`*^9, 
  3.739603788079698*^9}, {3.739610791308304*^9, 3.739610795136523*^9}, {
  3.7396111928719335`*^9, 3.7396112008418117`*^9}, {3.739611241623871*^9, 
  3.7396112432801003`*^9}, {3.7396112985865145`*^9, 3.7396113067614193`*^9}, {
  3.739611375209972*^9, 3.739611443862623*^9}, {3.7396115139867396`*^9, 
  3.7396118012657647`*^9}, {3.739612743208028*^9, 3.739612823478346*^9}, {
  3.7396150734137497`*^9, 
  3.7396150734137497`*^9}},ExpressionUUID->"2cf3dd60-df5e-4e4a-a1cd-\
e27f4562c9a8"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusGraphPermutations", "[", "l_", "]"}], ":=", 
  RowBox[{"GroupBy", "[", 
   RowBox[{
    RowBox[{"edgeListPermutations", "[", "l", "]"}], ",", 
    "canonicalEdgeList"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7381506392824955`*^9, 3.738150654168544*^9}, {
   3.738150684727375*^9, 3.738150691892763*^9}, 3.738150723191734*^9, {
   3.7381509258187513`*^9, 3.738150930414444*^9}, {3.738220256802577*^9, 
   3.738220260912097*^9}, {3.738311955477944*^9, 3.73831195564983*^9}, 
   3.738388221425913*^9},
 CellLabel->"In[30]:=",ExpressionUUID->"235a3e05-2de2-450b-9104-2eda287cb919"],

Cell[BoxData[
 RowBox[{
  RowBox[{"subgraphPermutations", "[", "l_", "]"}], ":=", 
  RowBox[{"GroupBy", "[", 
   RowBox[{
    RowBox[{"Select", "[", 
     RowBox[{
      RowBox[{"edgeListPermutations", "[", "l", "]"}], ",", 
      RowBox[{
       RowBox[{"And", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"Length", "[", "#", "]"}], ">", "0"}], ",", 
         RowBox[{"ConnectedGraphQ", "[", 
          RowBox[{"Graph", "[", "#", "]"}], "]"}]}], "]"}], "&"}]}], "]"}], 
    ",", "canonicalEdgeList"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7381333925754437`*^9, 3.7381334460314445`*^9}, {
  3.738133483692442*^9, 3.7381335313974442`*^9}, {3.7381509383031178`*^9, 
  3.7381509502494574`*^9}, {3.7381509996842957`*^9, 3.7381510488301067`*^9}, {
  3.7381511649945273`*^9, 3.7381511666845245`*^9}, {3.7381512118445373`*^9, 
  3.738151213454547*^9}, {3.738151246774571*^9, 3.7381513648446493`*^9}, {
  3.738220307490137*^9, 3.738220310005724*^9}, {3.738311956950189*^9, 
  3.738311957106574*^9}},
 CellLabel->"In[31]:=",ExpressionUUID->"d2dc7c5a-be7d-42aa-8630-d3df0ae96e4d"],

Cell[BoxData[
 RowBox[{
  RowBox[{"generateSubgraphs", "[", "l_", "]"}], ":=", 
  RowBox[{"DeleteDuplicates", "[", 
   RowBox[{"Map", "[", 
    RowBox[{"canonicalEdgeList", ",", 
     RowBox[{"Select", "[", 
      RowBox[{
       RowBox[{"edgeListPermutations", "[", "l", "]"}], ",", 
       RowBox[{
        RowBox[{"And", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"Length", "[", "#", "]"}], ">", "0"}], ",", 
          RowBox[{"ConnectedGraphQ", "[", 
           RowBox[{"Graph", "[", "#", "]"}], "]"}]}], "]"}], "&"}]}], "]"}]}],
     "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7381514669945636`*^9, 3.738151501794524*^9}, {
  3.7383119614503336`*^9, 3.7383119616533175`*^9}},
 CellLabel->"In[32]:=",ExpressionUUID->"397ff26a-d79a-4c5e-bdea-dccccf902a13"],

Cell[BoxData[
 RowBox[{
  RowBox[{"complementEdgeList", "[", 
   RowBox[{"l_", ",", "edgeList_"}], "]"}], ":=", 
  RowBox[{"Complement", "[", 
   RowBox[{
    RowBox[{"EdgeList", "[", 
     RowBox[{"CompleteGraph", "[", "l", "]"}], "]"}], ",", "edgeList"}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.7381320648048058`*^9, 3.738132094808774*^9}},
 CellLabel->"In[33]:=",ExpressionUUID->"8402f768-6c83-4662-a913-6f3deefce798"],

Cell[BoxData[
 RowBox[{
  RowBox[{"generateCensusEquationCases", "[", 
   RowBox[{"l_", ",", "edgeLists_", ",", "vertexCounts_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"relevantSubgraphs", "=", 
      RowBox[{"Map", "[", 
       RowBox[{"canonicalEdgeList", ",", 
        RowBox[{"Values", "[", 
         RowBox[{"subgraphEdgeLists", "[", 
          RowBox[{"[", 
           RowBox[{"Keys", "[", 
            RowBox[{"Select", "[", 
             RowBox[{"subgraphVertexCounts", ",", 
              RowBox[{
               RowBox[{"#", "\[LessEqual]", "l"}], "&"}]}], "]"}], "]"}], 
           "]"}], "]"}], "]"}]}], "]"}]}], "}"}], ",", 
    RowBox[{"MapThread", "[", 
     RowBox[{
      RowBox[{"Function", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"edgeList", ",", "vertexCount"}], "}"}], ",", 
        RowBox[{"With", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"permutations", "=", 
            RowBox[{
             RowBox[{"subgraphPermutations", "[", "vertexCount", "]"}], "[", 
             RowBox[{"canonicalEdgeList", "[", "edgeList", "]"}], "]"}]}], 
           "}"}], ",", 
          RowBox[{"AssociationMap", "[", 
           RowBox[{
            RowBox[{"Function", "[", 
             RowBox[{
              RowBox[{"{", "pattern", "}"}], ",", 
              RowBox[{"Function", "[", 
               RowBox[{
                RowBox[{"Evaluate", "[", 
                 RowBox[{"{", "n", "}"}], "]"}], ",", 
                RowBox[{"Evaluate", "[", 
                 RowBox[{
                  RowBox[{
                   RowBox[{"Count", "[", 
                    RowBox[{"permutations", ",", 
                    RowBox[{"permutation_", "/;", 
                    RowBox[{"And", "[", 
                    RowBox[{
                    RowBox[{"ContainsAll", "[", 
                    RowBox[{"permutation", ",", "pattern"}], "]"}], ",", 
                    RowBox[{"ContainsNone", "[", 
                    RowBox[{
                    RowBox[{"complementEdgeList", "[", 
                    RowBox[{
                    RowBox[{"VertexCount", "[", "pattern", "]"}], ",", 
                    "pattern"}], "]"}], ",", "permutation"}], "]"}]}], 
                    "]"}]}]}], "]"}], "/", 
                   RowBox[{"Length", "[", "permutations", "]"}]}], 
                  RowBox[{"Binomial", "[", 
                   RowBox[{
                    RowBox[{"n", "-", "l"}], ",", 
                    RowBox[{"vertexCount", "-", 
                    RowBox[{"VertexCount", "[", "pattern", "]"}]}]}], "]"}]}],
                  "]"}]}], "]"}]}], "]"}], ",", 
            RowBox[{"Intersection", "[", 
             RowBox[{
              RowBox[{"generateSubgraphs", "[", "l", "]"}], ",", 
              "relevantSubgraphs"}], "]"}]}], "]"}]}], "]"}]}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"edgeLists", ",", "vertexCounts"}], "}"}]}], "]"}]}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.7371909190216875`*^9, 3.7371909615578136`*^9}, {
   3.7371910090429416`*^9, 3.737191127292081*^9}, {3.7371911660302057`*^9, 
   3.7371912109488354`*^9}, {3.7371913098691497`*^9, 3.737191483967659*^9}, {
   3.7371915227720504`*^9, 3.7371915719923086`*^9}, {3.7371916304947505`*^9, 
   3.7371916943503976`*^9}, {3.7371917469809866`*^9, 
   3.7371919567845926`*^9}, {3.7371920534523687`*^9, 
   3.7371921929666405`*^9}, {3.7371922511619644`*^9, 
   3.7371922903952265`*^9}, {3.737192366996497*^9, 3.737192368496601*^9}, {
   3.7371924438880563`*^9, 3.737192475064398*^9}, 3.7371933091039968`*^9, {
   3.737193481386216*^9, 3.737193485011224*^9}, {3.7371935173505564`*^9, 
   3.7371935180538163`*^9}, {3.7371935982748423`*^9, 3.737193626531497*^9}, {
   3.7371937233773994`*^9, 3.737193762305298*^9}, {3.7371938197168107`*^9, 
   3.7371938371177483`*^9}, {3.737193893851119*^9, 3.7371939020938773`*^9}, {
   3.737193951409049*^9, 3.7371939519402847`*^9}, 3.7371939847556705`*^9, 
   3.737194015284382*^9, {3.737195137139206*^9, 3.7371951374205804`*^9}, {
   3.7371952085225954`*^9, 3.7371952097522273`*^9}, {3.737195332493462*^9, 
   3.7371954000247107`*^9}, {3.737195559126811*^9, 3.7371955601580377`*^9}, {
   3.7371992647623005`*^9, 3.7371992995932536`*^9}, {3.7371993424699802`*^9, 
   3.737199350303976*^9}, {3.7371994995341597`*^9, 3.7371995019348707`*^9}, {
   3.7371996932270255`*^9, 3.737199696246256*^9}, {3.737199863103365*^9, 
   3.7371999021840024`*^9}, {3.7372001138593454`*^9, 3.737200218843464*^9}, {
   3.737200262602254*^9, 3.737200312007194*^9}, {3.7372004818735623`*^9, 
   3.7372004866959777`*^9}, {3.737200622992078*^9, 3.7372006252794647`*^9}, {
   3.7372006829249907`*^9, 3.737200683711352*^9}, {3.7372007751709146`*^9, 
   3.737200790792493*^9}, {3.7372008529020844`*^9, 3.737200902888094*^9}, {
   3.737200934007626*^9, 3.7372010018060308`*^9}, {3.737201096966225*^9, 
   3.7372011024367533`*^9}, {3.737201206023258*^9, 3.737201210675687*^9}, {
   3.737201549911256*^9, 3.7372015959076242`*^9}, {3.737201656833252*^9, 
   3.7372016898533735`*^9}, {3.737201847753005*^9, 3.7372018661990824`*^9}, {
   3.737201996929192*^9, 3.737201999044198*^9}, 3.7372022822901006`*^9, {
   3.7381305492167673`*^9, 3.738130558888653*^9}, 3.738130668323333*^9, {
   3.738131975413802*^9, 3.738132015053773*^9}, {3.738132113232771*^9, 
   3.738132116596779*^9}, {3.7381324252588153`*^9, 3.7381324270268145`*^9}, 
   3.7381325424418154`*^9, {3.7381326494319706`*^9, 3.7381326512379665`*^9}, {
   3.7381416366423554`*^9, 3.7381416366423554`*^9}, {3.73814168968653*^9, 
   3.7381416905374756`*^9}, {3.7381417400575795`*^9, 3.738141740062578*^9}, {
   3.738301074758974*^9, 3.7383010764775887`*^9}, {3.7383011355812263`*^9, 
   3.7383011471129293`*^9}, {3.7383013094180565`*^9, 
   3.7383013118415966`*^9}, {3.7383013789781265`*^9, 
   3.7383013984182677`*^9}, {3.738301690660181*^9, 3.738301747281213*^9}, 
   3.7383018251014676`*^9, {3.7383020973600616`*^9, 3.738302175854188*^9}, {
   3.738302263425823*^9, 3.738302376930275*^9}, {3.738302449547202*^9, 
   3.738302455174039*^9}, {3.7383024995884027`*^9, 3.7383025530427194`*^9}, {
   3.738302735829548*^9, 3.7383027484419727`*^9}, 3.738302829579948*^9, 
   3.7383028622331996`*^9, {3.7383029287630816`*^9, 3.7383030049900336`*^9}, {
   3.7383030815654154`*^9, 3.7383031008987055`*^9}, {3.7383031831669683`*^9, 
   3.7383031851513376`*^9}, {3.7383032322351494`*^9, 
   3.7383032483027325`*^9}, {3.738303297558304*^9, 3.7383033007499647`*^9}, {
   3.7383034142867126`*^9, 3.738303418882205*^9}, {3.7383035393393865`*^9, 
   3.7383035492438164`*^9}, {3.7383036682387533`*^9, 3.7383036712771063`*^9}, 
   3.7383037347921534`*^9, {3.7383851721162815`*^9, 3.7383851748819056`*^9}, 
   3.7383852415899525`*^9, {3.7385681982135515`*^9, 3.7385682057760477`*^9}, {
   3.738568302432314*^9, 3.738568319635424*^9}, {3.7385686574740524`*^9, 
   3.7385686671615667`*^9}},
 CellLabel->"In[34]:=",ExpressionUUID->"70762168-279d-43f3-9bef-366febfa375b"],

Cell[BoxData[
 RowBox[{
  RowBox[{"subgraphUnionReduceCount", "[", 
   RowBox[{
   "l_", ",", "permutationList_", ",", "additionalSubgraph_", ",", 
    "subsetSize_"}], "]"}], ":=", 
  RowBox[{"Map", "[", 
   RowBox[{
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"Total", "[", 
        RowBox[{"#", "[", 
         RowBox[{"[", 
          RowBox[{"All", ",", "1"}], "]"}], "]"}], "]"}], ",", 
       RowBox[{"#", "[", 
        RowBox[{"[", 
         RowBox[{"1", ",", "2"}], "]"}], "]"}]}], "}"}], "&"}], ",", 
    RowBox[{"GatherBy", "[", 
     RowBox[{
      RowBox[{"Flatten", "[", 
       RowBox[{
        RowBox[{"Table", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"permutationList", "[", 
             RowBox[{"[", 
              RowBox[{"i", ",", "1"}], "]"}], "]"}], ",", 
            RowBox[{"Union", "[", 
             RowBox[{
              RowBox[{"permutationList", "[", 
               RowBox[{"[", 
                RowBox[{"i", ",", "2"}], "]"}], "]"}], ",", 
              RowBox[{"Flatten", "[", "subset", "]"}]}], "]"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"i", ",", "1", ",", 
            RowBox[{"Length", "[", "permutationList", "]"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"subset", ",", 
            RowBox[{"Subsets", "[", 
             RowBox[{"additionalSubgraph", ",", 
              RowBox[{"{", "subsetSize", "}"}]}], "]"}]}], "}"}]}], "]"}], 
        ",", "1"}], "]"}], ",", 
      RowBox[{
       RowBox[{"canonicalEdgeList", "[", 
        RowBox[{"#", "[", 
         RowBox[{"[", "2", "]"}], "]"}], "]"}], "&"}]}], "]"}]}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.7368639046059165`*^9, 3.7368639860444756`*^9}, {
   3.736864042966934*^9, 3.736864064402283*^9}, {3.736864110954133*^9, 
   3.7368641689862275`*^9}, {3.7368645871545753`*^9, 
   3.7368646258634014`*^9}, {3.7368646597822404`*^9, 
   3.7368646623313437`*^9}, {3.7368647141347857`*^9, 
   3.7368647335708947`*^9}, {3.736864856882242*^9, 3.736864962105094*^9}, {
   3.736865008472895*^9, 3.7368650998585167`*^9}, {3.736865157592785*^9, 
   3.7368651938545957`*^9}, {3.7368652286547356`*^9, 3.736865291179308*^9}, {
   3.736865356537162*^9, 3.7368654263987927`*^9}, {3.7368654671119833`*^9, 
   3.7368655002470064`*^9}, {3.736865583370613*^9, 3.7368656048496747`*^9}, {
   3.7368658732521486`*^9, 3.736865881885519*^9}, {3.73686591286583*^9, 
   3.736865913181919*^9}, {3.7368660058075714`*^9, 3.736866081896742*^9}, 
   3.7368661498063993`*^9, {3.736866224301371*^9, 3.7368662273436623`*^9}, {
   3.7368662821379914`*^9, 3.7368663062374744`*^9}, {3.736866464088295*^9, 
   3.736866464350946*^9}, {3.736866507359744*^9, 3.736866515648119*^9}, {
   3.7368665634081497`*^9, 3.736866568116276*^9}, {3.7368666555042686`*^9, 
   3.7368667375612717`*^9}, {3.7368723613934736`*^9, 
   3.7368723873778543`*^9}, {3.736872534799721*^9, 3.7368725715654793`*^9}, {
   3.736872623065396*^9, 3.7368726603622265`*^9}, {3.736872699846636*^9, 
   3.7368727385029764`*^9}, {3.7368727804091005`*^9, 
   3.7368727915654936`*^9}, {3.736872823284239*^9, 3.7368728285498548`*^9}, {
   3.7368728830498524`*^9, 3.7368729176435986`*^9}, {3.7369627722304173`*^9, 
   3.7369628088397565`*^9}, {3.736962950261752*^9, 3.7369629504492474`*^9}, {
   3.736963672062504*^9, 3.736963674453121*^9}, {3.7369639523859205`*^9, 
   3.736963961760909*^9}, {3.7370939027552233`*^9, 3.7370939073802023`*^9}, {
   3.7370939412727327`*^9, 3.737093984315217*^9}, {3.7370940160931215`*^9, 
   3.7370940195679636`*^9}, {3.7370941797242613`*^9, 3.737094180819784*^9}, {
   3.737094366996439*^9, 3.737094368699561*^9}, {3.7370948693884735`*^9, 
   3.7370949193512278`*^9}, {3.7370949727869625`*^9, 3.737094973990224*^9}, {
   3.7370950096701164`*^9, 3.737095011373246*^9}, {3.7370951047541757`*^9, 
   3.737095106019657*^9}, {3.7370954633705883`*^9, 3.7370954701830873`*^9}, {
   3.7371279015573545`*^9, 3.7371279687773886`*^9}, {3.737171633812333*^9, 
   3.7371716365780516`*^9}, {3.73717642437097*^9, 3.7371764262148333`*^9}, {
   3.7383260670921345`*^9, 3.738326068362129*^9}, {3.7383262849415164`*^9, 
   3.7383262851664505`*^9}},
 CellLabel->"In[35]:=",ExpressionUUID->"9e92cbfb-6111-42aa-ad9a-7817d3e05b62"],

Cell[BoxData[
 RowBox[{
  RowBox[{"subgraphUnionPermutations", "[", 
   RowBox[{"l_", ",", "permutationCounts_", ",", "subgraphPermutations_"}], 
   "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"permutationList", "=", 
      RowBox[{"{", 
       RowBox[{"{", 
        RowBox[{"1", ",", 
         RowBox[{"{", "}"}]}], "}"}], "}"}]}], "}"}], ",", 
    RowBox[{
     RowBox[{"Do", "[", 
      RowBox[{
       RowBox[{"If", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"permutationCounts", "[", 
           RowBox[{"[", "o", "]"}], "]"}], ">", "0"}], ",", 
         RowBox[{"permutationList", "=", 
          RowBox[{"subgraphUnionReduceCount", "[", 
           RowBox[{"l", ",", "permutationList", ",", 
            RowBox[{"subgraphPermutations", "[", 
             RowBox[{"[", "o", "]"}], "]"}], ",", 
            RowBox[{"permutationCounts", "[", 
             RowBox[{"[", "o", "]"}], "]"}]}], "]"}]}]}], "]"}], ",", 
       RowBox[{"{", 
        RowBox[{"o", ",", "1", ",", 
         RowBox[{"Length", "[", "subgraphPermutations", "]"}]}], "}"}]}], 
      "]"}], ";", "permutationList"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.736862209050584*^9, 3.7368622753074408`*^9}, {
   3.736862311010367*^9, 3.7368623200890017`*^9}, {3.736862356108943*^9, 
   3.736862424114693*^9}, {3.7368625268287525`*^9, 3.7368626268104177`*^9}, {
   3.736863426012098*^9, 3.736863496651097*^9}, {3.7368638244783983`*^9, 
   3.736863899130375*^9}, {3.7368645482600727`*^9, 3.7368645639226303`*^9}, {
   3.7368663540798583`*^9, 3.736866366613887*^9}, {3.7368730338935213`*^9, 
   3.7368730689561033`*^9}, 3.7368732949253435`*^9, {3.7369240470149217`*^9, 
   3.736924073233756*^9}, {3.7369241950618677`*^9, 3.7369242236556215`*^9}, {
   3.7369248861867776`*^9, 3.7369248951710987`*^9}, {3.7369249495930214`*^9, 
   3.7369249525306196`*^9}, {3.736963004558632*^9, 3.736963009605487*^9}, {
   3.736963060395006*^9, 3.7369630839105415`*^9}, {3.736963853481349*^9, 
   3.7369638817765465`*^9}, {3.736963969604661*^9, 3.7369639752609076`*^9}, {
   3.73709307516753*^9, 3.7370930804291244`*^9}, {3.737093682045456*^9, 
   3.737093689826665*^9}, {3.737093735809129*^9, 3.737093761607617*^9}, {
   3.7370939099980807`*^9, 3.737093963458561*^9}, {3.737176582247695*^9, 
   3.7371765846852026`*^9}},
 CellLabel->"In[36]:=",ExpressionUUID->"d1af2056-6cbd-4eb7-b490-f1c1cd06a6ae"],

Cell[BoxData[
 RowBox[{
  RowBox[{"countToCensusEquationPattern", "[", 
   RowBox[{"permutationCount_", ",", "exponents_", ",", "maxExponents_"}], 
   "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"variableList", "=", 
      RowBox[{"Map", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"Symbol", "[", 
          RowBox[{"\"\<v\>\"", "<>", 
           RowBox[{"ToString", "[", "#", "]"}]}], "]"}], "&"}], ",", 
        RowBox[{"Range", "[", 
         RowBox[{"Length", "[", "exponents", "]"}], "]"}]}], "]"}]}], "}"}], 
    ",", 
    RowBox[{"permutationCount", " ", 
     RowBox[{"Apply", "[", 
      RowBox[{"Times", ",", 
       RowBox[{"MapThread", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"#1", "^", "#2"}], "&"}], ",", 
         RowBox[{"{", 
          RowBox[{"variableList", ",", 
           RowBox[{"(", 
            RowBox[{
             RowBox[{"Values", "[", "maxExponents", "]"}], "-", "exponents"}],
             ")"}]}], "}"}]}], "]"}]}], "]"}], 
     RowBox[{"Apply", "[", 
      RowBox[{"Times", ",", 
       RowBox[{"MapThread", "[", 
        RowBox[{
         RowBox[{
          RowBox[{
           RowBox[{"(", 
            RowBox[{"1", "-", "#1"}], ")"}], "^", "#2"}], "&"}], ",", 
         RowBox[{"{", 
          RowBox[{"variableList", ",", "exponents"}], "}"}]}], "]"}]}], 
      "]"}]}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.736930496600772*^9, 3.7369305344445305`*^9}, {
   3.7369305884438515`*^9, 3.7369305888507524`*^9}, {3.7369306347720056`*^9, 
   3.736930651990733*^9}, {3.7369309302719903`*^9, 3.73693093502265*^9}, {
   3.73693162781876*^9, 3.736931631834486*^9}, {3.736932050826231*^9, 
   3.736932085170103*^9}, {3.7370928793673177`*^9, 3.7370928822892227`*^9}, 
   3.73709293535819*^9, {3.7370937970277696`*^9, 3.7370938016453705`*^9}, {
   3.737100030480432*^9, 3.73710004862648*^9}, {3.7371001886458683`*^9, 
   3.7371001957240286`*^9}, {3.737100317330165*^9, 3.737100355434292*^9}, {
   3.7371800060021887`*^9, 3.7371800114865584`*^9}, 3.738385266964814*^9, {
   3.738386324435354*^9, 3.738386355517463*^9}, {3.7383866052901278`*^9, 
   3.7383866275561347`*^9}},
 CellLabel->"In[37]:=",ExpressionUUID->"de64e8b6-2f5f-45da-83bf-1e05602777a7"],

Cell[BoxData[
 RowBox[{
  RowBox[{"generateCensusEquationPatterns", "[", "l_", "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"relevantSubgraphsKeys", "=", 
      RowBox[{"Map", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"Key", "[", 
          RowBox[{"canonicalEdgeList", "[", "#", "]"}], "]"}], "&"}], ",", 
        RowBox[{"Values", "[", 
         RowBox[{"subgraphEdgeLists", "[", 
          RowBox[{"[", 
           RowBox[{"Keys", "[", 
            RowBox[{"Select", "[", 
             RowBox[{"subgraphVertexCounts", ",", 
              RowBox[{
               RowBox[{"#", "\[LessEqual]", "l"}], "&"}]}], "]"}], "]"}], 
           "]"}], "]"}], "]"}]}], "]"}]}], "}"}], ",", 
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"subgraphPermutations", "=", 
        RowBox[{
         RowBox[{"subgraphPermutations", "[", "l", "]"}], "[", 
         RowBox[{"[", "relevantSubgraphsKeys", "]"}], "]"}]}], "}"}], ",", 
      RowBox[{"With", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"subgraphPermutationLengths", "=", 
          RowBox[{"Map", "[", 
           RowBox[{"Length", ",", "subgraphPermutations"}], "]"}]}], "}"}], 
        ",", 
        RowBox[{"With", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"variableList", "=", 
            RowBox[{"Map", "[", 
             RowBox[{
              RowBox[{
               RowBox[{"Symbol", "[", 
                RowBox[{"\"\<i\>\"", "<>", 
                 RowBox[{"ToString", "[", "#", "]"}]}], "]"}], "&"}], ",", 
              RowBox[{"Range", "[", 
               RowBox[{"Length", "[", "subgraphPermutations", "]"}], "]"}]}], 
             "]"}]}], "}"}], ",", 
          RowBox[{"With", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{"iteratorSequence", "=", 
              RowBox[{"Replace", "[", 
               RowBox[{
                RowBox[{"MapThread", "[", 
                 RowBox[{
                  RowBox[{
                   RowBox[{"{", 
                    RowBox[{"#1", ",", "0", ",", "#2"}], "}"}], "&"}], ",", 
                  RowBox[{"{", 
                   RowBox[{"variableList", ",", 
                    RowBox[{
                    "Values", "[", "subgraphPermutationLengths", "]"}]}], 
                   "}"}]}], "]"}], ",", 
                RowBox[{
                 RowBox[{"head_", "[", "arg__", "]"}], "\[RuleDelayed]", 
                 RowBox[{"Sequence", "[", "arg", "]"}]}]}], "]"}]}], "}"}], 
            ",", 
            RowBox[{"Module", "[", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"equationPattern", "=", 
                RowBox[{"AssociationMap", "[", 
                 RowBox[{
                  RowBox[{"0", "&"}], ",", 
                  RowBox[{"generateCensusGraphs", "[", "l", "]"}]}], "]"}]}], 
               "}"}], ",", 
              RowBox[{
               RowBox[{"Do", "[", 
                RowBox[{
                 RowBox[{
                  RowBox[{"equationPattern", "[", 
                   RowBox[{"canonicalEdgeList", "[", 
                    RowBox[{"permutations", "[", 
                    RowBox[{"[", "2", "]"}], "]"}], "]"}], "]"}], "+=", 
                  RowBox[{"countToCensusEquationPattern", "[", 
                   RowBox[{
                    RowBox[{"permutations", "[", 
                    RowBox[{"[", "1", "]"}], "]"}], ",", "variableList", ",", 
                    "subgraphPermutationLengths"}], "]"}]}], ",", 
                 "iteratorSequence", ",", 
                 RowBox[{"{", 
                  RowBox[{"permutations", ",", 
                   RowBox[{"subgraphUnionPermutations", "[", 
                    RowBox[{
                    "l", ",", "variableList", ",", "subgraphPermutations"}], 
                    "]"}]}], "}"}]}], "]"}], ";", 
               RowBox[{"Map", "[", 
                RowBox[{
                 RowBox[{
                  RowBox[{"Function", "[", 
                   RowBox[{
                    RowBox[{"Evaluate", "[", 
                    RowBox[{"Map", "[", 
                    RowBox[{
                    RowBox[{
                    RowBox[{"Symbol", "[", 
                    RowBox[{"\"\<v\>\"", "<>", 
                    RowBox[{"ToString", "[", "#", "]"}]}], "]"}], "&"}], ",", 
                    RowBox[{"Range", "[", 
                    RowBox[{"Length", "[", "variableList", "]"}], "]"}]}], 
                    "]"}], "]"}], ",", 
                    RowBox[{"Evaluate", "[", 
                    RowBox[{"Simplify", "[", "#", "]"}], "]"}]}], "]"}], 
                  "&"}], ",", "equationPattern"}], "]"}]}]}], "]"}]}], 
           "]"}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7368620747439694`*^9, 3.73686220609317*^9}, {
   3.7368723292349114`*^9, 3.7368723321568003`*^9}, {3.7368732288784456`*^9, 
   3.736873233362859*^9}, {3.736924093749347*^9, 3.73692409710874*^9}, {
   3.736925028921147*^9, 3.7369250407181153`*^9}, {3.736930090865651*^9, 
   3.7369302197570105`*^9}, {3.736930350662617*^9, 3.7369304422562265`*^9}, {
   3.736930480585087*^9, 3.736930481693863*^9}, {3.736930541256999*^9, 
   3.7369305855687227`*^9}, {3.736930677959363*^9, 3.736930714287613*^9}, {
   3.7369307801469173`*^9, 3.736930888819516*^9}, {3.7369309589757624`*^9, 
   3.736931064115635*^9}, {3.7369310972249775`*^9, 3.736931144553237*^9}, {
   3.736931206225023*^9, 3.736931388553241*^9}, {3.7369314568499837`*^9, 
   3.7369314686312404`*^9}, {3.736931515443719*^9, 3.736931530365603*^9}, {
   3.736931619146904*^9, 3.7369316470219784`*^9}, {3.736931706373144*^9, 
   3.7369317235137215`*^9}, {3.7369318040449743`*^9, 3.736931809654358*^9}, {
   3.7369318732325916`*^9, 3.7369318734668446`*^9}, {3.7369320066074667`*^9, 
   3.7369320362012224`*^9}, {3.7369321082013636`*^9, 
   3.7369321153262215`*^9}, {3.7369630577279053`*^9, 
   3.7369630578681917`*^9}, {3.7369638622312355`*^9, 3.736963862403223*^9}, {
   3.7369638933390307`*^9, 3.736963914995316*^9}, {3.7369639843076944`*^9, 
   3.736963984495284*^9}, {3.7369640924465294`*^9, 3.7369640951807814`*^9}, {
   3.7369641544152927`*^9, 3.7369642379932632`*^9}, {3.736964268102768*^9, 
   3.7369642743995175`*^9}, 3.7370133952500186`*^9, {3.7370904236808076`*^9, 
   3.73709044753259*^9}, {3.73709048154729*^9, 3.7370904860474243`*^9}, {
   3.73709268834449*^9, 3.737092703138937*^9}, {3.737092759682399*^9, 
   3.737092767823226*^9}, 3.737092885570449*^9, {3.737092939140195*^9, 
   3.7370930137056117`*^9}, 3.7370930726675687`*^9, {3.737093769253213*^9, 
   3.7370937871594615`*^9}, 3.7370951232205157`*^9, 3.7370955522102966`*^9, {
   3.7370976341989117`*^9, 3.73709763491752*^9}, {3.7370992862167034`*^9, 
   3.737099288576076*^9}, {3.73709956206876*^9, 3.737099562678155*^9}, {
   3.7371002994973726`*^9, 3.7371003133219924`*^9}, {3.7371024634813223`*^9, 
   3.737102464699977*^9}, 3.7371105633002605`*^9, {3.737110613149648*^9, 
   3.7371106200572624`*^9}, {3.737122157077678*^9, 3.7371221572376823`*^9}, {
   3.7371226122973647`*^9, 3.737122613367858*^9}, {3.737123094079757*^9, 
   3.737123094194767*^9}, {3.7371231323247447`*^9, 3.737123156809746*^9}, {
   3.7371269292328434`*^9, 3.737126961767844*^9}, {3.737126998607885*^9, 
   3.737127024537984*^9}, {3.7371274085773845`*^9, 3.737127417062354*^9}, {
   3.737128085927352*^9, 3.737128086172352*^9}, {3.737128662036066*^9, 
   3.737128662131033*^9}, {3.737171663718549*^9, 3.7371716638904114`*^9}, {
   3.737171696531046*^9, 3.7371716966561766`*^9}, 3.7371764447529726`*^9, 
   3.737176510623138*^9, 3.73717775861413*^9, {3.738326089096265*^9, 
   3.738326095201125*^9}, {3.738326186438466*^9, 3.7383262257123594`*^9}, {
   3.7383262603074493`*^9, 3.7383262604624248`*^9}, {3.738385260561928*^9, 
   3.7383852686523356`*^9}, {3.7383855783162727`*^9, 
   3.7383855788630147`*^9}, {3.73838591683914*^9, 3.7383860040359917`*^9}, {
   3.7383861799882293`*^9, 3.7383862288665395`*^9}, {3.7383865704743547`*^9, 
   3.738386575848139*^9}, {3.7383866425587873`*^9, 3.7383866539762964`*^9}, 
   3.738388191395053*^9, {3.738563179656104*^9, 3.7385631884529676`*^9}, {
   3.738563230618552*^9, 3.7385632366029143`*^9}, {3.7385633354618516`*^9, 
   3.738563353466031*^9}, {3.7385683275573125`*^9, 3.738568330697785*^9}},
 CellLabel->"In[38]:=",ExpressionUUID->"1c9eadcc-efe2-4752-8bb8-6265a2725a2b"],

Cell[BoxData[
 RowBox[{
  RowBox[{"exponentGenerator", "[", 
   RowBox[{"n_", ",", "p_", ",", "l_", ",", "cases_"}], "]"}], ":=", 
  RowBox[{"Map", "[", 
   RowBox[{
    RowBox[{
     RowBox[{
      RowBox[{"(", 
       RowBox[{"1", "-", 
        RowBox[{
         RowBox[{"binomialCompensator", "[", 
          RowBox[{"l", ",", "n"}], "]"}], "p"}]}], ")"}], "^", "#"}], "&"}], 
    ",", "cases"}], "]"}]}]], "Input",
 CellChangeTimes->{
  3.734769910448643*^9, {3.7347699875016947`*^9, 3.7347699877360682`*^9}, {
   3.734770020833612*^9, 3.734770021192988*^9}, {3.7377075065036707`*^9, 
   3.737707508151589*^9}, 3.738139591786312*^9},
 CellLabel->"In[39]:=",ExpressionUUID->"1e61f050-4ff7-4775-9a92-f4c97c814bfc"],

Cell[BoxData[
 RowBox[{
  RowBox[{"equationGenerator", "[", 
   RowBox[{
   "l_", ",", "vertexCounts_", ",", "censusGraphCounts_", ",", 
    "equationCases_", ",", "equationPatterns_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"exponentiatedCases", "=", 
      RowBox[{"MapThread", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"Function", "[", 
          RowBox[{
           RowBox[{"{", "p", "}"}], ",", 
           RowBox[{"Evaluate", "[", 
            RowBox[{"exponentGenerator", "[", 
             RowBox[{"n", ",", "p", ",", "#1", ",", 
              RowBox[{"Map", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"#", "[", "n", "]"}], "&"}], ",", "#2"}], "]"}]}], 
             "]"}], "]"}]}], "]"}], "&"}], ",", 
        RowBox[{"{", 
         RowBox[{"vertexCounts", ",", 
          RowBox[{"Map", "[", 
           RowBox[{"Values", ",", 
            RowBox[{"equationCases", "[", "l", "]"}]}], "]"}]}], "}"}]}], 
       "]"}]}], "}"}], ",", 
    RowBox[{"Map", "[", 
     RowBox[{
      RowBox[{"Function", "[", 
       RowBox[{
        RowBox[{"{", "variableList", "}"}], ",", 
        RowBox[{"Map", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"Function", "[", 
            RowBox[{
             RowBox[{"Evaluate", "[", 
              RowBox[{"{", 
               RowBox[{"n", ",", "ps"}], "}"}], "]"}], ",", 
             RowBox[{"Evaluate", "[", 
              RowBox[{"#", "[", 
               RowBox[{"ReplaceAll", "[", 
                RowBox[{"variableList", ",", 
                 RowBox[{"List", "->", "Sequence"}]}], "]"}], "]"}], "]"}]}], 
            "]"}], "&"}], ",", 
          RowBox[{"equationPatterns", "[", "l", "]"}]}], "]"}]}], "]"}], ",", 
      RowBox[{"AssociationMap", "[", 
       RowBox[{
        RowBox[{
         RowBox[{"Product", "[", 
          RowBox[{
           RowBox[{
            RowBox[{"exponentiatedCases", "[", 
             RowBox[{"#", "[", 
              RowBox[{"[", "i", "]"}], "]"}], "]"}], "[", 
            RowBox[{"Quiet", "[", 
             RowBox[{
              RowBox[{"Part", "[", 
               RowBox[{"ps", ",", "i"}], "]"}], ",", 
              RowBox[{"{", 
               StyleBox[
                RowBox[{"Part", "::", "partd"}], "MessageName"], "}"}]}], 
             "]"}], "]"}], ",", 
           RowBox[{"{", 
            RowBox[{"i", ",", "1", ",", 
             RowBox[{"Length", "[", "#", "]"}]}], "}"}]}], "]"}], "&"}], ",", 
        RowBox[{"Subsets", "[", 
         RowBox[{
          RowBox[{"Keys", "[", "exponentiatedCases", "]"}], ",", 
          RowBox[{"{", 
           RowBox[{"1", ",", 
            RowBox[{"Min", "[", 
             RowBox[{
              RowBox[{"Length", "[", "exponentiatedCases", "]"}], ",", 
              RowBox[{
               RowBox[{"censusGraphCounts", "[", "l", "]"}], "-", "1"}]}], 
             "]"}]}], "}"}]}], "]"}]}], "]"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7352756031379924`*^9, 3.735275639528492*^9}, {
   3.7352756903879957`*^9, 3.735275742528637*^9}, {3.735275937754409*^9, 
   3.735275939488785*^9}, {3.7352759823792744`*^9, 3.7352759846917763`*^9}, 
   3.7352762960170965`*^9, {3.7352764584114733`*^9, 3.7352764608647337`*^9}, {
   3.7352765424091535`*^9, 3.7352765461747694`*^9}, {3.7353666949348097`*^9, 
   3.735366720995802*^9}, {3.7353667543924093`*^9, 3.7353667576111565`*^9}, {
   3.735366881558025*^9, 3.73536690293606*^9}, {3.7353669330207*^9, 
   3.735366940764683*^9}, {3.7353690726656895`*^9, 3.735369101151944*^9}, {
   3.735369240917036*^9, 3.735369249567311*^9}, 3.7353698146454477`*^9, {
   3.7353698457556343`*^9, 3.7353698465837746`*^9}, {3.7353808512441854`*^9, 
   3.7353808533930397`*^9}, {3.737180342384794*^9, 3.7371803477781096`*^9}, {
   3.737180681711589*^9, 3.7371807001540465`*^9}, {3.7371809482334695`*^9, 
   3.7371809488115892`*^9}, {3.737181077970046*^9, 3.737181096743803*^9}, {
   3.7371811343171787`*^9, 3.7371812034491897`*^9}, 3.73718124279597*^9, {
   3.7371822107318373`*^9, 3.7371822174976177`*^9}, {3.7371833397232184`*^9, 
   3.737183386230687*^9}, {3.7371897627206383`*^9, 3.7371897714427447`*^9}, {
   3.737202170621154*^9, 3.7372021724973507`*^9}, {3.7372022326213765`*^9, 
   3.7372022431235833`*^9}, 3.7381393565376*^9, {3.7381417400875797`*^9, 
   3.7381417400925803`*^9}, {3.7383884460168076`*^9, 3.738388470244931*^9}, {
   3.7383885010630255`*^9, 3.738388504057489*^9}, {3.7385638935133924`*^9, 
   3.7385639058416243`*^9}},
 CellLabel->"In[40]:=",ExpressionUUID->"4aeb1401-5e32-48c7-bacb-45d2ec78dbb8"],

Cell[BoxData[
 RowBox[{
  RowBox[{"expectedValueGenerator", "[", "equations_", "]"}], ":=", 
  RowBox[{"Association", "[", 
   RowBox[{"KeyValueMap", "[", 
    RowBox[{
     RowBox[{"Function", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"type", ",", "equationsPerType"}], "}"}], ",", 
       RowBox[{"type", "\[Rule]", 
        RowBox[{"Map", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"Function", "[", 
            RowBox[{
             RowBox[{"Evaluate", "[", 
              RowBox[{"{", 
               RowBox[{"n", ",", "ps"}], "}"}], "]"}], ",", 
             RowBox[{"Evaluate", "[", 
              RowBox[{
               RowBox[{"Binomial", "[", 
                RowBox[{"n", ",", "type"}], "]"}], 
               RowBox[{"#", "[", 
                RowBox[{"n", ",", "ps"}], "]"}]}], "]"}]}], "]"}], "&"}], ",",
           "equationsPerType", ",", 
          RowBox[{"{", "2", "}"}]}], "]"}]}]}], "]"}], ",", "equations"}], 
    "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.735370918000594*^9, 3.735371064436266*^9}, {
   3.7354673988771687`*^9, 3.735467406361414*^9}, {3.7354676429424253`*^9, 
   3.735467649942428*^9}, {3.7371862436304817`*^9, 3.73718624634912*^9}, {
   3.7371863448454733`*^9, 3.737186345454831*^9}, {3.7371879565038524`*^9, 
   3.737187958598826*^9}, {3.73718808603985*^9, 3.7371880933578205`*^9}, {
   3.7392872633527*^9, 3.7392872793501325`*^9}, 3.7396041988820457`*^9, {
   3.7396045093652925`*^9, 3.7396045117558002`*^9}},
 CellLabel->"In[41]:=",ExpressionUUID->"d32e9cd1-d009-44bd-a964-f046c4a20a63"],

Cell[BoxData[
 RowBox[{
  RowBox[{"likelihoodGenerator", "[", "equations_", "]"}], ":=", 
  RowBox[{"Association", "[", 
   RowBox[{"KeyValueMap", "[", 
    RowBox[{
     RowBox[{"Function", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"type", ",", "equationsPerType"}], "}"}], ",", 
       RowBox[{"type", "->", 
        RowBox[{"Association", "[", 
         RowBox[{"KeyValueMap", "[", 
          RowBox[{
           RowBox[{"Function", "[", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"key", ",", "equation"}], "}"}], ",", 
             RowBox[{"key", "\[Rule]", 
              RowBox[{"Function", "[", 
               RowBox[{
                RowBox[{"Evaluate", "[", 
                 RowBox[{"{", 
                  RowBox[{"n", ",", "ps", ",", "counts", ",", "d"}], "}"}], 
                 "]"}], ",", 
                RowBox[{"Evaluate", "[", 
                 RowBox[{"Apply", "[", 
                  RowBox[{"Times", ",", 
                   RowBox[{"MapThread", "[", 
                    RowBox[{
                    RowBox[{
                    RowBox[{
                    RowBox[{"#1", "[", 
                    RowBox[{"n", ",", "ps"}], "]"}], "^", 
                    RowBox[{"(", 
                    RowBox[{"d", " ", 
                    RowBox[{"Quiet", "[", 
                    RowBox[{
                    RowBox[{"Part", "[", 
                    RowBox[{"counts", ",", "#2"}], "]"}], ",", 
                    RowBox[{"{", 
                    RowBox[{"Part", "::", "partd"}], "}"}]}], "]"}]}], 
                    ")"}]}], "&"}], ",", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"Values", "[", "equation", "]"}], ",", 
                    RowBox[{"Range", "[", 
                    RowBox[{"Length", "[", "equation", "]"}], "]"}]}], 
                    "}"}]}], "]"}]}], "]"}], "]"}]}], "]"}]}]}], "]"}], ",", 
           "equationsPerType"}], "]"}], "]"}]}]}], "]"}], ",", "equations"}], 
    "]"}], "]"}]}]], "Input",
 CellChangeTimes->{
  3.735367015974065*^9, {3.7353693067984924`*^9, 3.7353693399728484`*^9}, {
   3.7353693849239683`*^9, 3.7353693870646067`*^9}, {3.735369448513337*^9, 
   3.7353694496165895`*^9}, {3.7353694918069105`*^9, 3.735369730396118*^9}, {
   3.73718346669519*^9, 3.7371834720700517`*^9}, {3.7371835634578695`*^9, 
   3.737183577253115*^9}, {3.73718361150125*^9, 3.7371836179856215`*^9}, {
   3.737183682355975*^9, 3.737183705213524*^9}, {3.737183795178996*^9, 
   3.737183835576651*^9}, {3.7371839297007904`*^9, 3.73718396229727*^9}, 
   3.7371839966012354`*^9, {3.7371841230047903`*^9, 3.7371841421767683`*^9}, {
   3.737184324371116*^9, 3.7371843572152576`*^9}, {3.737184443635771*^9, 
   3.7371844505224876`*^9}, {3.737184548558538*^9, 3.737184561655691*^9}, {
   3.7371846118340673`*^9, 3.7371846205842104`*^9}, 3.737184863285651*^9, {
   3.7371849098332453`*^9, 3.737184914473882*^9}, {3.737185029134258*^9, 
   3.737185029259266*^9}, {3.7371850606464334`*^9, 3.737185077782172*^9}, {
   3.737185122424445*^9, 3.7371851472996054`*^9}, {3.7371857197712584`*^9, 
   3.737185731781542*^9}, {3.7371857877394867`*^9, 3.737185795877201*^9}, {
   3.737186216354732*^9, 3.7371862242706957`*^9}, {3.7371863475640774`*^9, 
   3.737186348235978*^9}, {3.7371871722888756`*^9, 3.7371871746326127`*^9}, {
   3.7371873360494432`*^9, 3.7371873529065423`*^9}, {3.7377056553742895`*^9, 
   3.7377056756869316`*^9}, {3.73770640375528*^9, 3.737706407475604*^9}},
 CellLabel->"In[42]:=",ExpressionUUID->"f58c7147-c401-4f20-9710-c90eef4a5973"],

Cell[BoxData[
 RowBox[{
  RowBox[{"degreesOfFreedomCompensator", "[", 
   RowBox[{"l_", ",", "s_", ",", "n_"}], "]"}], ":=", 
  RowBox[{
   RowBox[{"1", "/", 
    RowBox[{"Binomial", "[", 
     RowBox[{"l", ",", "2"}], "]"}]}], 
   RowBox[{"1", "/", "s"}], " ", 
   RowBox[{
    RowBox[{"Binomial", "[", 
     RowBox[{"n", ",", "2"}], "]"}], "/", 
    RowBox[{"Binomial", "[", 
     RowBox[{"n", ",", "l"}], "]"}]}]}]}]], "Input",
 CellChangeTimes->{{3.73770548609304*^9, 3.737705505577413*^9}, {
   3.7377055447963*^9, 3.737705547249421*^9}, 3.7377056523899403`*^9, {
   3.737705704593035*^9, 3.7377057425463047`*^9}, 3.737705811452552*^9, {
   3.7377059008744273`*^9, 3.737705904296297*^9}, {3.7377122291872416`*^9, 
   3.7377122302966127`*^9}, {3.7377138267289734`*^9, 3.737713852963355*^9}, {
   3.737783150105669*^9, 3.7377831538101997`*^9}},
 CellLabel->"In[43]:=",ExpressionUUID->"b814b62f-7a71-4c38-a8f3-2fe3261e17fb"],

Cell[BoxData[
 RowBox[{
  RowBox[{"estimateLikelihood", "[", 
   RowBox[{
   "l_", ",", "s_", ",", "n_", ",", "counts_", ",", "equations_", ",", 
    "likelihoods_", ",", "iterations_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"likelihoodsReduced", "=", 
      RowBox[{"Function", "[", 
       RowBox[{
        RowBox[{"{", "ps", "}"}], ",", 
        RowBox[{"Evaluate", "[", 
         RowBox[{"Quiet", "[", 
          RowBox[{"likelihoods", "[", 
           RowBox[{"n", ",", "ps", ",", "counts", ",", 
            RowBox[{"degreesOfFreedomCompensator", "[", 
             RowBox[{"l", ",", "s", ",", "n"}], "]"}]}], "]"}], "]"}], 
         "]"}]}], "]"}]}], "}"}], ",", 
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"variableList", "=", 
        RowBox[{"Variables", "[", 
         RowBox[{"Last", "[", 
          RowBox[{"Quiet", "[", 
           RowBox[{"likelihoodsReduced", "[", "ps", "]"}], "]"}], "]"}], 
         "]"}]}], "}"}], ",", 
      RowBox[{"With", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"maxLikelihood", "=", 
          RowBox[{"NArgMax", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
              RowBox[{"likelihoodsReduced", "[", "variableList", "]"}], ",", 
              RowBox[{"0", "<", "variableList", "<", "0.5"}]}], "}"}], ",", 
            "variableList"}], "]"}]}], "}"}], ",", 
        RowBox[{"With", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"metropolisHastings", "=", 
            RowBox[{"metropolisHastings", "[", 
             RowBox[{"likelihoodsReduced", ",", "maxLikelihood", ",", 
              RowBox[{"Function", "[", 
               RowBox[{
                RowBox[{"{", "x", "}"}], ",", 
                RowBox[{"BetaDistribution", "[", 
                 RowBox[{
                  RowBox[{
                   RowBox[{"10", "^", 
                    RowBox[{"-", "2"}]}], "+", 
                   RowBox[{"1000", "x"}]}], ",", 
                  RowBox[{
                   RowBox[{"10", "^", 
                    RowBox[{"-", "2"}]}], "+", 
                   RowBox[{"1000", 
                    RowBox[{"(", 
                    RowBox[{"1", "-", "x"}], ")"}]}]}]}], "]"}]}], "]"}], ",", 
              RowBox[{"iterations", " ", 
               RowBox[{"Length", "[", "variableList", "]"}]}], ",", "0"}], 
             "]"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"maxLikelihood", ",", "metropolisHastings"}], "}"}]}], 
         "]"}]}], "]"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7348413695411153`*^9, 3.7348413919675217`*^9}, {
   3.734841422025948*^9, 3.734841422351342*^9}, {3.7348414543530765`*^9, 
   3.734841454901239*^9}, {3.734841530670024*^9, 3.734841530915455*^9}, {
   3.7348450791174335`*^9, 3.734845127933775*^9}, {3.734845257701926*^9, 
   3.734845266017824*^9}, {3.734845466367338*^9, 3.7348455376004453`*^9}, {
   3.7348455895837083`*^9, 3.7348456050005646`*^9}, {3.734847486804532*^9, 
   3.7348475438272057`*^9}, {3.7348476577341213`*^9, 
   3.7348478309475236`*^9}, {3.7350206241465025`*^9, 3.73502071990738*^9}, {
   3.7350281022974596`*^9, 3.7350281030941787`*^9}, {3.73502815433222*^9, 
   3.7350281628376126`*^9}, {3.7350284061985197`*^9, 3.735028437456747*^9}, {
   3.735028519385786*^9, 3.735028520854538*^9}, {3.735028555056635*^9, 
   3.7350285569630146`*^9}, {3.735028670417948*^9, 3.7350286763646545`*^9}, {
   3.735030451916094*^9, 3.7350304899787955`*^9}, {3.7350310135318527`*^9, 
   3.735031030994496*^9}, {3.7350329463317194`*^9, 3.7350329465457673`*^9}, {
   3.7350333121364*^9, 3.7350333209468036`*^9}, {3.7350354172056923`*^9, 
   3.735035422445413*^9}, {3.735035649052846*^9, 3.7350356515684724`*^9}, {
   3.7350357916221185`*^9, 3.735035813596781*^9}, {3.735037848263956*^9, 
   3.7350378555296087`*^9}, {3.7350379576214433`*^9, 3.735037960558823*^9}, {
   3.7350380711243496`*^9, 3.735038105216382*^9}, {3.7350405020113745`*^9, 
   3.735040518897925*^9}, {3.7350407614963613`*^9, 3.7350407647533445`*^9}, {
   3.7350408427634916`*^9, 3.7350408523544006`*^9}, {3.7350409440167484`*^9, 
   3.7350409456117783`*^9}, {3.7350416831155744`*^9, 3.735041685293721*^9}, {
   3.7350418111896057`*^9, 3.7350418416683445`*^9}, {3.735043701381558*^9, 
   3.7350437135083246`*^9}, {3.7350443400753484`*^9, 3.735044340891649*^9}, {
   3.7350650051857285`*^9, 3.735065032591831*^9}, {3.7350650815450983`*^9, 
   3.735065125841837*^9}, {3.7350652618418407`*^9, 3.735065279951212*^9}, {
   3.7350663985754147`*^9, 3.735066525247283*^9}, {3.7350667725344477`*^9, 
   3.73506677620647*^9}, {3.7350670231719007`*^9, 3.735067024906411*^9}, {
   3.7350673299376755`*^9, 3.7350673313126755`*^9}, {3.7350673718125305`*^9, 
   3.735067374500032*^9}, {3.73511328257766*^9, 3.7351132827597003`*^9}, {
   3.7351133240006533`*^9, 3.7351133363693247`*^9}, {3.7353597561322403`*^9, 
   3.7353597614106445`*^9}, {3.735361638323146*^9, 3.73536164679177*^9}, {
   3.735448006798401*^9, 3.735448009480666*^9}, {3.735448384230728*^9, 
   3.7354483866645975`*^9}, {3.7354577598633623`*^9, 3.7354578189726443`*^9}, 
   3.7354670282839737`*^9, {3.735468772360389*^9, 3.735468785907267*^9}, {
   3.735469022153014*^9, 3.735469024793604*^9}, {3.7355342951160493`*^9, 
   3.7355343169185376`*^9}, {3.7355352719112177`*^9, 3.735535291348213*^9}, {
   3.7355354855388737`*^9, 3.735535488351227*^9}, {3.7355355493802967`*^9, 
   3.735535552208284*^9}, {3.7355355912483835`*^9, 3.735535610058448*^9}, {
   3.735535767006852*^9, 3.7355357682566977`*^9}, {3.735536128216129*^9, 
   3.735536156590424*^9}, {3.735747189201001*^9, 3.735747194388363*^9}, {
   3.7364952591325407`*^9, 3.736495266397805*^9}, {3.736495514406537*^9, 
   3.736495528246684*^9}, {3.7371881975021114`*^9, 3.737188227749084*^9}, {
   3.7371888156015625`*^9, 3.7371888316508474`*^9}, {3.7374590161660023`*^9, 
   3.737459074350091*^9}, {3.7374591134470673`*^9, 3.737459124400049*^9}, {
   3.7377058600775523`*^9, 3.7377058983900614`*^9}, 3.7383867828363*^9},
 CellLabel->"In[44]:=",ExpressionUUID->"95565ad1-9ffa-4fb7-8714-63a9f427d30a"],

Cell[BoxData[
 RowBox[{
  RowBox[{"mahalanobisDistance", "[", 
   RowBox[{"data_", ",", "point_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"mean", "=", 
       RowBox[{"Mean", "[", "data", "]"}]}], ",", 
      RowBox[{"covariance", "=", 
       RowBox[{"Covariance", "[", "data", "]"}]}]}], "}"}], ",", 
    RowBox[{"Sqrt", "[", 
     RowBox[{"Dot", "[", 
      RowBox[{
       RowBox[{"mean", "-", "point"}], ",", 
       RowBox[{"Inverse", "[", "covariance", "]"}], ",", 
       RowBox[{"mean", "-", "point"}]}], "]"}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7384205735754147`*^9, 3.7384206300344152`*^9}, {
   3.7384207098731437`*^9, 3.738420725054147*^9}, 3.738429197249491*^9, {
   3.7384298616130953`*^9, 3.7384298638300905`*^9}, {3.7384300358730917`*^9, 
   3.738430037543133*^9}, 3.7384303267465515`*^9, 3.738430425446516*^9},
 CellLabel->"In[45]:=",ExpressionUUID->"f76cc1e2-71eb-420a-8139-f32f2e1842ea"],

Cell[BoxData[
 RowBox[{
  RowBox[{"verifyMahalanobisDistance", "[", 
   RowBox[{
   "l_", ",", "s_", ",", "n_", ",", "equations_", ",", "likelihoods_", ",", 
    "countsList_", ",", "ps_"}], "]"}], ":=", 
  RowBox[{"Transpose", "[", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"maxLikelihoodAndMetropolisHastings", "=", 
         RowBox[{"estimateLikelihood", "[", 
          RowBox[{
          "l", ",", "s", ",", "n", ",", "counts", ",", "equations", ",", 
           "likelihoods", ",", "6000"}], "]"}]}], "}"}], ",", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"First", "[", "maxLikelihoodAndMetropolisHastings", "]"}], 
         ",", 
         RowBox[{"mahalanobisDistance", "[", 
          RowBox[{
           RowBox[{"Last", "[", "maxLikelihoodAndMetropolisHastings", "]"}], 
           ",", "ps"}], "]"}]}], "}"}]}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"counts", ",", "countsList"}], "}"}]}], "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7374585656834106`*^9, 3.7374585719846787`*^9}, {
   3.737458702082532*^9, 3.7374587071294003`*^9}, {3.737459283482933*^9, 
   3.737459358718137*^9}, {3.737459503251254*^9, 3.737459503548117*^9}, {
   3.737459593860529*^9, 3.737459752841359*^9}, {3.7374598405373*^9, 
   3.7374598441308937`*^9}, {3.737459916954107*^9, 3.7374599999739943`*^9}, {
   3.7374600458129573`*^9, 3.737460055781714*^9}, {3.7374601420671625`*^9, 
   3.7374601557390347`*^9}, {3.7374601986942673`*^9, 3.737460232555744*^9}, {
   3.737460276567533*^9, 3.737460277848919*^9}, {3.737460319865056*^9, 
   3.7374603786907377`*^9}, {3.737460432174413*^9, 3.7374604597281094`*^9}, {
   3.737460514386742*^9, 3.737460533949477*^9}, {3.73746060307286*^9, 
   3.737460605119732*^9}, {3.737461244582952*^9, 3.7374612857488613`*^9}, {
   3.7374697546084967`*^9, 3.7374697549087377`*^9}, {3.7377060749836893`*^9, 
   3.7377060832963066`*^9}, {3.7377826250922565`*^9, 3.7377826575367904`*^9}, 
   3.73778304373158*^9, {3.7377849040371833`*^9, 3.7377849334117193`*^9}, 
   3.738386785398802*^9, {3.738389315287181*^9, 3.738389321855975*^9}, {
   3.7383946820883565`*^9, 3.738394787859023*^9}, {3.738394837732353*^9, 
   3.738394888553083*^9}, {3.7383953299303837`*^9, 3.7383953671038656`*^9}, {
   3.7384207338401456`*^9, 3.738420746917142*^9}, {3.738420778261141*^9, 
   3.738420786431145*^9}, 3.738476398187941*^9, {3.739177985901559*^9, 
   3.739177994245349*^9}, {3.739178039135925*^9, 3.7391780937766895`*^9}, {
   3.7391782263234797`*^9, 3.739178231620453*^9}},
 CellLabel->"In[46]:=",ExpressionUUID->"328ae089-5efe-4169-8d76-6f80a94d9666"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Derived Input", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7353639674740095`*^9, {3.736572676118946*^9, 3.736572678040842*^9}, {
   3.7377170173360643`*^9, 3.737717024273598*^9}, {3.7382206185097246`*^9, 
   3.7382206490253363`*^9}, 3.7382208446345882`*^9, {3.738389084089754*^9, 
   3.738389084308507*^9}},ExpressionUUID->"0c294d4a-3dd4-489c-a6a5-\
29f3f0f6efe3"],

Cell["\<\
In this subsection, the functions defined above are used to derive various \
inputs, such as the likelihood functions. These can be described \
analytically, which speeds up their use in the example below.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7396037971660557`*^9, 3.7396038967853084`*^9}, {3.739603926918128*^9, 
  3.73960397384673*^9}, {3.7396113158866987`*^9, 
  3.7396113187773232`*^9}},ExpressionUUID->"9ba1deda-dbc7-4600-8f72-\
c0576d48cd4e"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusGraphCounts", "=", 
   RowBox[{"AssociationMap", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"Length", "[", 
       RowBox[{"generateCensusGraphs", "[", "#", "]"}], "]"}], "&"}], ",", 
     "censusSizes"}], "]"}]}], ";"}]], "Input",
 CellLabel->"In[47]:=",ExpressionUUID->"0b72d5cf-67ba-4509-8bf6-737b485ffa73"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusEquationCases", "=", 
   RowBox[{"AssociationMap", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"generateCensusEquationCases", "[", 
       RowBox[{"#", ",", "subgraphEdgeLists", ",", "subgraphVertexCounts"}], 
       "]"}], "&"}], ",", "censusSizes"}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.737201699177382*^9, 3.7372017248391857`*^9}, 
   3.737201871484048*^9, 3.7372021038742547`*^9, {3.738080956413657*^9, 
   3.7380809760387964`*^9}, {3.7380810946325636`*^9, 
   3.7380810956481714`*^9}, {3.7381306865555067`*^9, 3.7381307045398865`*^9}, 
   3.7381393565226*^9, 3.7381416366523232`*^9, {3.7381416896976366`*^9, 
   3.7381416905424404`*^9}, 3.7381417400675797`*^9, {3.7383037456222353`*^9, 
   3.7383037458877325`*^9}, 3.7383037773244476`*^9, {3.73832604610639*^9, 
   3.7383260503221407`*^9}, {3.7383851441394234`*^9, 
   3.7383851635463696`*^9}, {3.7383852326212034`*^9, 3.73838523832432*^9}, {
   3.7385635564220295`*^9, 3.7385635590001535`*^9}, {3.738563918281064*^9, 
   3.7385639356183524`*^9}},
 CellLabel->"In[48]:=",ExpressionUUID->"a4375eef-890f-495c-84aa-b1dc3584cbd7"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusEquationPatterns", "=", 
   RowBox[{"AssociationMap", "[", 
    RowBox[{"generateCensusEquationPatterns", ",", "censusSizes"}], "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{{3.7370993101336837`*^9, 3.7370993793422756`*^9}, {
   3.737099441990983*^9, 3.737099453975218*^9}, {3.7370996071758223`*^9, 
   3.737099797115885*^9}, 3.737099835278698*^9, {3.7370998763933477`*^9, 
   3.7370998799247503`*^9}, {3.737099914369787*^9, 3.7370999151199284`*^9}, {
   3.7370999877358828`*^9, 3.737099990204484*^9}, {3.737100204002689*^9, 
   3.737100216132698*^9}, 3.737100363857397*^9, {3.7371791132755795`*^9, 
   3.737179173994894*^9}, {3.7371792149704466`*^9, 3.737179277776556*^9}, {
   3.737179312177744*^9, 3.737179314177745*^9}, {3.7371796198757715`*^9, 
   3.737179621375763*^9}, {3.737179748411098*^9, 3.737179780256611*^9}, 
   3.737180255884934*^9, 3.738139356527636*^9, 3.738141740072618*^9, {
   3.738385200512704*^9, 3.738385215688022*^9}, 3.738385255718173*^9, {
   3.7383866922059665`*^9, 3.738386719262823*^9}, 3.7383881237255473`*^9, 
   3.73838856829716*^9, {3.738568574620062*^9, 3.738568576760664*^9}},
 CellLabel->"In[49]:=",ExpressionUUID->"1e2e3fc2-7a60-4164-8224-04b17740da46"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusEquations", "=", 
   RowBox[{"AssociationMap", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"equationGenerator", "[", 
       RowBox[{
       "#", ",", "subgraphVertexCounts", ",", "censusGraphCounts", ",", 
        "censusEquationCases", ",", "censusEquationPatterns"}], "]"}], "&"}], 
     ",", "censusSizes"}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.735275110731691*^9, 3.735275113294199*^9}, {
   3.735275423841095*^9, 3.735275424091091*^9}, {3.735275780481762*^9, 
   3.7352757855755177`*^9}, {3.735276182895054*^9, 3.7352761912075624`*^9}, 
   3.735276568299779*^9, 3.735359162443801*^9, 3.7353592127562666`*^9, {
   3.735361868367427*^9, 3.735361871929908*^9}, {3.7353659936141357`*^9, 
   3.735366002520336*^9}, 3.735366563145329*^9, {3.7353667305509524`*^9, 
   3.735366731519698*^9}, {3.7353669450146666`*^9, 3.7353669778077726`*^9}, {
   3.735369271322112*^9, 3.7353692787126117`*^9}, {3.735369965688987*^9, 
   3.735369969907599*^9}, 3.7371803488718605`*^9, 3.737181208361622*^9, 
   3.7371823702360325`*^9, 3.737182423098477*^9, 3.7371828289688683`*^9, {
   3.7371831130662403`*^9, 3.7371831160193615`*^9}, 3.737183359680952*^9, 
   3.737183391980836*^9, {3.7371837812005053`*^9, 3.7371837888821173`*^9}, 
   3.7371841567983522`*^9, 3.737184284683075*^9, 3.737184589301655*^9, 
   3.7371852883496995`*^9, {3.7371853631482306`*^9, 3.7371853712576075`*^9}, {
   3.7371859261980643`*^9, 3.737185928947917*^9}, 3.7371867525670385`*^9, 
   3.7371871863844957`*^9, 3.7371873226902065`*^9, 3.7372022485808225`*^9, 
   3.7372023005088744`*^9, 3.7381417401075807`*^9, {3.7383851818505526`*^9, 
   3.7383851887193766`*^9}, 3.7383852347305784`*^9, 3.7383868093501062`*^9, {
   3.738388521569976*^9, 3.7383885246480875`*^9}, {3.73838856541848*^9, 
   3.7383886073028493`*^9}, {3.7385638138071012`*^9, 3.738563820731596*^9}, {
   3.7385638736071043`*^9, 3.7385639118436995`*^9}},
 CellLabel->"In[50]:=",ExpressionUUID->"0a7d89ec-f1df-432f-97a2-8575ef91e55a"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusExpectedValue", "=", 
   RowBox[{"expectedValueGenerator", "[", "censusEquations", "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{
  3.735370887896298*^9, {3.7353710687487745`*^9, 3.735371102499424*^9}, {
   3.737182837038171*^9, 3.737182842850535*^9}, 3.7371861014119606`*^9, 
   3.737187965117856*^9, {3.738386812214569*^9, 3.7383868151520977`*^9}, {
   3.7383886140194035`*^9, 3.738388621183421*^9}, {3.73960419844458*^9, 
   3.7396042235111113`*^9}, 3.7396044652230406`*^9, 3.7396045229902253`*^9, 
   3.739604564531704*^9},
 CellLabel->"In[51]:=",ExpressionUUID->"3b6bbdbe-5fae-4734-93cd-60d1191d0637"],

Cell[BoxData[
 RowBox[{
  RowBox[{"censusLikelihoods", "=", 
   RowBox[{"likelihoodGenerator", "[", "censusEquations", "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{{3.7352765988622837`*^9, 3.735276606471657*^9}, {
   3.7352766852685394`*^9, 3.7352767127684517`*^9}, {3.735359214339942*^9, 
   3.7353592162917166`*^9}, 3.7353618692580347`*^9, 3.7353619390895386`*^9, 
   3.7353659989733534`*^9, {3.7353665252146225`*^9, 3.7353665258552527`*^9}, 
   3.735366560989085*^9, {3.7353697376762133`*^9, 3.7353697502857294`*^9}, 
   3.7371826246623383`*^9, 3.7371828278280897`*^9, 3.7371833932777224`*^9, {
   3.7371838954001102`*^9, 3.737183906796817*^9}, 3.737183971505275*^9, 
   3.737184146518744*^9, {3.7371845129020844`*^9, 3.7371845277586555`*^9}, 
   3.7371857446888113`*^9, {3.737187181205664*^9, 3.7371871845337887`*^9}, 
   3.737187271347001*^9, {3.7371873579410086`*^9, 3.737187361527706*^9}, {
   3.738386811006334*^9, 3.7383868144333477`*^9}, {3.738388609162236*^9, 
   3.738388611052847*^9}},
 CellLabel->"In[52]:=",ExpressionUUID->"84b8c709-f3bb-4db4-ae91-4a77e64d1f07"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Visualisation Functions", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7353639674740095`*^9, {3.736572676118946*^9, 3.736572678040842*^9}, {
   3.7377170173360643`*^9, 3.737717024273598*^9}, 3.7382208738065977`*^9, 
   3.7383890872460093`*^9, 
   3.7385852374984827`*^9},ExpressionUUID->"35fa132a-9aa0-48b3-a246-\
6544b82ffe0c"],

Cell["\<\
The following functions help visualise the model, the simulations and the \
estimations.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
   3.7396039886420097`*^9, 3.7396040023150253`*^9}, {3.7396040361908255`*^9, 
   3.739604051958947*^9}, 
   3.739611337558581*^9},ExpressionUUID->"a518538a-d923-48e3-bbb8-\
db6bad88fbfc"],

Cell[BoxData[
 RowBox[{
  RowBox[{"keySort", "[", 
   RowBox[{"keys_", ",", "vertexCounts_"}], "]"}], ":=", 
  RowBox[{"Sort", "[", 
   RowBox[{"keys", ",", 
    RowBox[{
     RowBox[{
      RowBox[{"First", "[", 
       RowBox[{"First", "[", 
        RowBox[{"Position", "[", 
         RowBox[{
          RowBox[{"Keys", "[", "vertexCounts", "]"}], ",", "#1"}], "]"}], 
        "]"}], "]"}], "<", 
      RowBox[{"First", "[", 
       RowBox[{"First", "[", 
        RowBox[{"Position", "[", 
         RowBox[{
          RowBox[{"Keys", "[", "vertexCounts", "]"}], ",", "#2"}], "]"}], 
        "]"}], "]"}]}], "&"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.7353707243385105`*^9, 3.735370732054475*^9}, {
  3.7381417400775795`*^9, 3.7381417400825834`*^9}, {3.738387626796776*^9, 
  3.738387636328024*^9}},
 CellLabel->"In[53]:=",ExpressionUUID->"5c7531cb-7d0a-4d52-9639-738b8e5811b4"],

Cell[BoxData[
 RowBox[{
  RowBox[{"visualiseLikelihood", "[", 
   RowBox[{
   "l_", ",", "s_", ",", "n_", ",", "counts_", ",", "equations_", ",", 
    "likelihoods_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"maxLikelihoodAndMetropolisHastings", "=", 
      RowBox[{"estimateLikelihood", "[", 
       RowBox[{
       "l", ",", "s", ",", "n", ",", "counts", ",", "equations", ",", 
        "likelihoods", ",", "10000"}], "]"}]}], "}"}], ",", 
    RowBox[{"With", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"expectedCounts", "=", 
        RowBox[{"Map", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"#", "[", 
            RowBox[{"n", ",", 
             RowBox[{"maxLikelihoodAndMetropolisHastings", "[", 
              RowBox[{"[", "1", "]"}], "]"}]}], "]"}], "&"}], ",", 
          RowBox[{"Values", "[", "equations", "]"}]}], "]"}]}], "}"}], ",", 
      RowBox[{"Column", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Grid", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
              RowBox[{"Join", "[", 
               RowBox[{
                RowBox[{"{", "\"\<\>\"", "}"}], ",", 
                RowBox[{"Map", "[", 
                 RowBox[{
                  RowBox[{
                   RowBox[{"\"\<p\>\"", "<>", 
                    RowBox[{"ToString", "[", "#", "]"}]}], "&"}], ",", 
                  RowBox[{"Range", "[", 
                   RowBox[{"Length", "[", 
                    RowBox[{"maxLikelihoodAndMetropolisHastings", "[", 
                    RowBox[{"[", "1", "]"}], "]"}], "]"}], "]"}]}], "]"}]}], 
               "]"}], ",", 
              RowBox[{"Join", "[", 
               RowBox[{
                RowBox[{"{", "\"\<Max likelihood\>\"", "}"}], ",", 
                RowBox[{"maxLikelihoodAndMetropolisHastings", "[", 
                 RowBox[{"[", "1", "]"}], "]"}]}], "]"}]}], "}"}], ",", 
            RowBox[{"Spacings", "\[Rule]", 
             RowBox[{"{", 
              RowBox[{"1", ",", "1"}], "}"}]}], ",", 
            RowBox[{"Dividers", "\[Rule]", 
             RowBox[{"{", 
              RowBox[{
               RowBox[{"{", 
                RowBox[{"False", ",", "True"}], "}"}], ",", 
               RowBox[{"{", 
                RowBox[{"False", ",", "True"}], "}"}]}], "}"}]}]}], "]"}], 
          ",", 
          RowBox[{"Row", "[", 
           RowBox[{"{", 
            RowBox[{"\"\<Goodness of fit: \>\"", ",", 
             RowBox[{"Mean", "[", 
              RowBox[{"MapThread", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"If", "[", 
                  RowBox[{
                   RowBox[{"#1", "<", "#2"}], ",", 
                   RowBox[{
                    RowBox[{"2", 
                    RowBox[{
                    RowBox[{"(", 
                    RowBox[{"1", "+", "#1"}], ")"}], "/", 
                    RowBox[{"(", 
                    RowBox[{"1", "+", "#2"}], ")"}]}]}], "-", "1"}], ",", 
                   RowBox[{
                    RowBox[{"2", 
                    RowBox[{
                    RowBox[{"(", 
                    RowBox[{"1", "+", "#2"}], ")"}], "/", 
                    RowBox[{"(", 
                    RowBox[{"1", "+", "#1"}], ")"}]}]}], "-", "1"}]}], "]"}], 
                 "&"}], ",", 
                RowBox[{"{", 
                 RowBox[{"counts", ",", 
                  RowBox[{
                   RowBox[{"Total", "[", "counts", "]"}], 
                   "expectedCounts"}]}], "}"}]}], "]"}], "]"}]}], "}"}], 
           "]"}], ",", 
          RowBox[{"samplingDescription", "[", 
           RowBox[{"maxLikelihoodAndMetropolisHastings", "[", 
            RowBox[{"[", "2", "]"}], "]"}], "]"}]}], "}"}], ",", 
        RowBox[{"Spacings", "\[Rule]", "1.5"}]}], "]"}]}], "]"}]}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.7348413695411153`*^9, 3.7348413919675217`*^9}, {
   3.734841422025948*^9, 3.734841422351342*^9}, {3.7348414543530765`*^9, 
   3.734841454901239*^9}, {3.734841530670024*^9, 3.734841530915455*^9}, {
   3.7348450791174335`*^9, 3.734845127933775*^9}, {3.734845257701926*^9, 
   3.734845266017824*^9}, {3.734845466367338*^9, 3.7348455376004453`*^9}, {
   3.7348455895837083`*^9, 3.7348456050005646`*^9}, {3.734847486804532*^9, 
   3.7348475438272057`*^9}, {3.7348476577341213`*^9, 
   3.7348478309475236`*^9}, {3.7350206241465025`*^9, 3.73502071990738*^9}, {
   3.7350281022974596`*^9, 3.7350281030941787`*^9}, {3.73502815433222*^9, 
   3.7350281628376126`*^9}, {3.7350284061985197`*^9, 3.735028437456747*^9}, {
   3.735028519385786*^9, 3.735028520854538*^9}, {3.735028555056635*^9, 
   3.7350285569630146`*^9}, {3.735028670417948*^9, 3.7350286763646545`*^9}, {
   3.735030451916094*^9, 3.7350304899787955`*^9}, {3.7350310135318527`*^9, 
   3.735031030994496*^9}, {3.7350329463317194`*^9, 3.7350329465457673`*^9}, {
   3.7350333121364*^9, 3.7350333209468036`*^9}, {3.7350354172056923`*^9, 
   3.735035422445413*^9}, {3.735035649052846*^9, 3.7350356515684724`*^9}, {
   3.7350357916221185`*^9, 3.735035813596781*^9}, {3.735037848263956*^9, 
   3.7350378555296087`*^9}, {3.7350379576214433`*^9, 3.735037960558823*^9}, {
   3.7350380711243496`*^9, 3.735038105216382*^9}, {3.7350405020113745`*^9, 
   3.735040518897925*^9}, {3.7350407614963613`*^9, 3.7350407647533445`*^9}, {
   3.7350408427634916`*^9, 3.7350408523544006`*^9}, {3.7350409440167484`*^9, 
   3.7350409456117783`*^9}, {3.7350416831155744`*^9, 3.735041685293721*^9}, {
   3.7350418111896057`*^9, 3.7350418416683445`*^9}, {3.735043701381558*^9, 
   3.7350437135083246`*^9}, {3.7350443400753484`*^9, 3.735044340891649*^9}, {
   3.7350650051857285`*^9, 3.735065032591831*^9}, {3.7350650815450983`*^9, 
   3.735065125841837*^9}, {3.7350652618418407`*^9, 3.735065279951212*^9}, {
   3.7350663985754147`*^9, 3.735066525247283*^9}, {3.7350667725344477`*^9, 
   3.73506677620647*^9}, {3.7350670231719007`*^9, 3.735067024906411*^9}, {
   3.7350673299376755`*^9, 3.7350673313126755`*^9}, {3.7350673718125305`*^9, 
   3.735067374500032*^9}, {3.73511328257766*^9, 3.7351132827597003`*^9}, {
   3.7351133240006533`*^9, 3.7351133363693247`*^9}, {3.7353597561322403`*^9, 
   3.7353597614106445`*^9}, {3.735361638323146*^9, 3.73536164679177*^9}, {
   3.735448006798401*^9, 3.735448009480666*^9}, {3.735448384230728*^9, 
   3.7354483866645975`*^9}, {3.7354577598633623`*^9, 3.7354578189726443`*^9}, 
   3.7354670282839737`*^9, {3.735468772360389*^9, 3.735468785907267*^9}, {
   3.735469022153014*^9, 3.735469024793604*^9}, {3.7355342951160493`*^9, 
   3.7355343169185376`*^9}, {3.7355352719112177`*^9, 3.735535291348213*^9}, {
   3.7355354855388737`*^9, 3.735535488351227*^9}, {3.7355355493802967`*^9, 
   3.735535552208284*^9}, {3.7355355912483835`*^9, 3.735535610058448*^9}, {
   3.735535767006852*^9, 3.7355357682566977`*^9}, {3.735536128216129*^9, 
   3.735536156590424*^9}, {3.735747189201001*^9, 3.735747194388363*^9}, {
   3.7364952591325407`*^9, 3.736495266397805*^9}, {3.736495514406537*^9, 
   3.736495528246684*^9}, {3.7371881975021114`*^9, 3.737188227749084*^9}, {
   3.7371888156015625`*^9, 3.7371888316508474`*^9}, {3.737459141274588*^9, 
   3.737459187768453*^9}, {3.7374592307243443`*^9, 3.7374592494890523`*^9}, {
   3.737705920843171*^9, 3.7377059263588195`*^9}, {3.738386828558488*^9, 
   3.738386831620989*^9}, {3.7392828224605436`*^9, 3.739282900740519*^9}, {
   3.7392829463409915`*^9, 3.7392831101541615`*^9}, {3.739283168300908*^9, 
   3.739283245261245*^9}, {3.739283285901444*^9, 3.7392832909004183`*^9}},
 CellLabel->"In[54]:=",ExpressionUUID->"021b107b-e74e-4038-b1b5-c07bd4b4dfd7"],

Cell[BoxData[
 RowBox[{
  RowBox[{"visualiseHistogram", "[", 
   RowBox[{"l_", ",", "n_", ",", "f_", ",", "counts_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"expectedMean", "=", 
       RowBox[{
        RowBox[{"Binomial", "[", 
         RowBox[{"n", ",", "l"}], "]"}], "f"}]}], ",", 
      RowBox[{"expectedStandardDeviation", "=", 
       RowBox[{"Sqrt", "[", 
        RowBox[{
         RowBox[{"Binomial", "[", 
          RowBox[{"n", ",", "l"}], "]"}], " ", "f", " ", 
         RowBox[{"(", 
          RowBox[{"1", "-", "f"}], ")"}]}], "]"}]}]}], "}"}], ",", 
    RowBox[{"Column", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"Grid", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{"\"\<\>\"", ",", "\"\<Observed\>\""}], "}"}], ",", 
            RowBox[{"{", 
             RowBox[{"\"\<Mean\>\"", ",", 
              RowBox[{"N", "[", 
               RowBox[{"Mean", "[", "counts", "]"}], "]"}]}], "}"}], ",", 
            RowBox[{"{", 
             RowBox[{"\"\<Std\>\"", ",", 
              RowBox[{"N", "[", 
               RowBox[{"StandardDeviation", "[", "counts", "]"}], "]"}]}], 
             "}"}]}], "}"}], ",", 
          RowBox[{"Dividers", "\[Rule]", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"False", ",", "True"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{"False", ",", "True"}], "}"}]}], "}"}]}]}], "]"}], ",", 
        RowBox[{"Show", "[", 
         RowBox[{
          RowBox[{"Histogram", "[", 
           RowBox[{"counts", ",", "Automatic", ",", "\"\<PDF\>\""}], "]"}], 
          ",", 
          RowBox[{"ImageSize", "\[Rule]", "200"}]}], "]"}]}], "}"}], ",", 
      RowBox[{"Alignment", "\[Rule]", "Center"}], ",", 
      RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.731300913777424*^9, 3.7313009543129945`*^9}, {
   3.731301181337264*^9, 3.7313012051210556`*^9}, {3.731301286942284*^9, 
   3.7313013499370203`*^9}, {3.731301532176286*^9, 3.7313015983239794`*^9}, {
   3.7313016604897594`*^9, 3.7313016961341934`*^9}, {3.7313018156152496`*^9, 
   3.7313018453682957`*^9}, {3.731301964872801*^9, 3.7313019652167253`*^9}, {
   3.7313021035913568`*^9, 3.7313021393921785`*^9}, {3.731302388293776*^9, 
   3.7313024780533695`*^9}, {3.7313026641610217`*^9, 3.731302702165084*^9}, {
   3.731302756639654*^9, 3.7313027664688196`*^9}, {3.7313027985503635`*^9, 
   3.731302801160035*^9}, {3.731304470797889*^9, 3.7313044730793743`*^9}, {
   3.7313047831474876`*^9, 3.731304904071822*^9}, {3.7313060750567355`*^9, 
   3.7313060936679697`*^9}, {3.7313186424511538`*^9, 3.731318651733404*^9}, {
   3.7313187057800694`*^9, 3.7313187096712437`*^9}, {3.731393109205428*^9, 
   3.7313931187571855`*^9}, {3.731393201310568*^9, 3.731393203940565*^9}, {
   3.7313932403070903`*^9, 3.731393252659262*^9}, {3.7313932975692368`*^9, 
   3.731393298268198*^9}, {3.731393352087734*^9, 3.7313933892781153`*^9}, {
   3.7313934916849256`*^9, 3.7313934926272573`*^9}, {3.7313935381889534`*^9, 
   3.7313935383600893`*^9}, {3.731393588343184*^9, 3.731393628799574*^9}, {
   3.731393714947275*^9, 3.731393731514054*^9}, {3.7313939891211243`*^9, 
   3.731394032109823*^9}, {3.731394086178258*^9, 3.73139408745649*^9}, {
   3.7313941584123588`*^9, 3.7313941634336753`*^9}, {3.731413019265785*^9, 
   3.7314130211566114`*^9}, {3.731413171914709*^9, 3.7314131874837513`*^9}, {
   3.7314132176641316`*^9, 3.7314132212281218`*^9}, {3.731413492642608*^9, 
   3.731413510488865*^9}, 3.731492481579705*^9, {3.732030200463811*^9, 
   3.732030201966612*^9}, {3.7354578381446533`*^9, 3.7354578386602645`*^9}, {
   3.735457883332015*^9, 3.7354578969102755`*^9}, 3.735464633524702*^9, {
   3.7354672140872374`*^9, 3.73546722018099*^9}, {3.735467707754939*^9, 
   3.7354677099580793`*^9}, {3.7377173140704255`*^9, 3.737717314461088*^9}, 
   3.7383868363397365`*^9, {3.7385835294559364`*^9, 3.738583626970359*^9}, {
   3.7385836608154006`*^9, 3.738583694375658*^9}},
 CellLabel->"In[55]:=",ExpressionUUID->"adeca30f-f28f-40de-85fe-2fbb1901961f"],

Cell[BoxData[
 RowBox[{
  RowBox[{"expectedMahalanobisDistances", "=", 
   RowBox[{"Function", "[", 
    RowBox[{
     RowBox[{"Evaluate", "[", 
      RowBox[{"{", "d", "}"}], "]"}], ",", 
     RowBox[{"Evaluate", "[", 
      RowBox[{"With", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"distribution", "=", 
          RowBox[{
           RowBox[{"x", "^", 
            RowBox[{"(", 
             RowBox[{"d", "-", "1"}], ")"}]}], " ", 
           RowBox[{"PDF", "[", 
            RowBox[{
             RowBox[{"NormalDistribution", "[", "]"}], ",", "x"}], "]"}]}]}], 
         "}"}], ",", 
        RowBox[{"ProbabilityDistribution", "[", 
         RowBox[{
          RowBox[{"distribution", "/", 
           RowBox[{"Integrate", "[", 
            RowBox[{"distribution", ",", 
             RowBox[{"{", 
              RowBox[{"x", ",", "0", ",", "Infinity"}], "}"}], ",", 
             RowBox[{"Assumptions", "\[Rule]", 
              RowBox[{"{", 
               RowBox[{"d", ">", "0"}], "}"}]}]}], "]"}]}], ",", 
          RowBox[{"{", 
           RowBox[{"x", ",", "0", ",", "Infinity"}], "}"}]}], "]"}]}], "]"}], 
      "]"}]}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.7385778792910547`*^9, 3.738577881275425*^9}, {
  3.7385781146684537`*^9, 3.738578131814981*^9}, {3.738579548201474*^9, 
  3.7385795888421073`*^9}, {3.738583109226392*^9, 3.738583194966305*^9}, {
  3.7385832369131107`*^9, 3.738583250720476*^9}},
 CellLabel->"In[56]:=",ExpressionUUID->"d43c99d6-185d-4365-abb2-b50f16c5caed"],

Cell[BoxData[
 RowBox[{
  RowBox[{"visualiseMahalanobisDistance", "[", 
   RowBox[{
   "l_", ",", "s_", ",", "n_", ",", "equations_", ",", "likelihoods_", ",", 
    "countsList_", ",", "ps_"}], "]"}], ":=", 
  RowBox[{"With", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"maxLikelihoodAndMahalanobisDistance", "=", 
      RowBox[{"verifyMahalanobisDistance", "[", 
       RowBox[{
       "l", ",", "s", ",", "n", ",", "equations", ",", "likelihoods", ",", 
        "countsList", ",", "ps"}], "]"}]}], "}"}], ",", 
    RowBox[{"Column", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"Grid", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"Join", "[", 
             RowBox[{
              RowBox[{"{", "\"\<\>\"", "}"}], ",", 
              RowBox[{"Map", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"\"\<p\>\"", "<>", 
                  RowBox[{"ToString", "[", "#", "]"}]}], "&"}], ",", 
                RowBox[{"Range", "[", 
                 RowBox[{"Length", "[", "ps", "]"}], "]"}]}], "]"}]}], "]"}], 
            ",", 
            RowBox[{"Join", "[", 
             RowBox[{
              RowBox[{"{", "\"\<Max likelihood\>\"", "}"}], ",", 
              RowBox[{"Mean", "[", 
               RowBox[{
               "First", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
               "]"}]}], "]"}]}], "}"}], ",", 
          RowBox[{"Spacings", "\[Rule]", 
           RowBox[{"{", 
            RowBox[{"1", ",", "1"}], "}"}]}], ",", 
          RowBox[{"Dividers", "\[Rule]", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"False", ",", "True"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{"False", ",", "True"}], "}"}]}], "}"}]}]}], "]"}], ",", 
        RowBox[{"Row", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"\"\<Cov:\>\"", ",", 
            RowBox[{"MatrixForm", "[", 
             RowBox[{"Covariance", "[", 
              RowBox[{
              "First", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
              "]"}], "]"}]}], "}"}], ",", "\"\< \>\""}], "]"}], ",", 
        RowBox[{"Grid", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
             "\"\<\>\"", ",", "\"\<Observed\>\"", ",", "\"\<Expected\>\""}], 
             "}"}], ",", 
            RowBox[{"{", 
             RowBox[{"\"\<Mean\>\"", ",", 
              RowBox[{"Mean", "[", 
               RowBox[{
               "Last", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
               "]"}], ",", 
              RowBox[{"N", "[", 
               RowBox[{"Mean", "[", 
                RowBox[{"expectedMahalanobisDistances", "[", 
                 RowBox[{"Length", "[", "ps", "]"}], "]"}], "]"}], "]"}]}], 
             "}"}], ",", 
            RowBox[{"{", 
             RowBox[{"\"\<Trimmed95\>\"", ",", 
              RowBox[{"TrimmedMean", "[", 
               RowBox[{
                RowBox[{
                "Last", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
                ",", 
                RowBox[{"{", 
                 RowBox[{"0", ",", "0.05"}], "}"}]}], "]"}], ",", 
              RowBox[{"TrimmedMean", "[", 
               RowBox[{
                RowBox[{"expectedMahalanobisDistances", "[", 
                 RowBox[{"Length", "[", "ps", "]"}], "]"}], ",", 
                RowBox[{"{", 
                 RowBox[{"0", ",", "0.05"}], "}"}]}], "]"}]}], "}"}], ",", 
            RowBox[{"{", 
             RowBox[{"\"\<Trimmed85\>\"", ",", 
              RowBox[{"TrimmedMean", "[", 
               RowBox[{
                RowBox[{
                "Last", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
                ",", 
                RowBox[{"{", 
                 RowBox[{"0", ",", "0.15"}], "}"}]}], "]"}], ",", 
              RowBox[{"TrimmedMean", "[", 
               RowBox[{
                RowBox[{"expectedMahalanobisDistances", "[", 
                 RowBox[{"Length", "[", "ps", "]"}], "]"}], ",", 
                RowBox[{"{", 
                 RowBox[{"0", ",", "0.15"}], "}"}]}], "]"}]}], "}"}], ",", 
            RowBox[{"{", 
             RowBox[{"\"\<Median\>\"", ",", 
              RowBox[{"Median", "[", 
               RowBox[{
               "Last", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
               "]"}], ",", 
              RowBox[{"N", "[", 
               RowBox[{"Median", "[", 
                RowBox[{"expectedMahalanobisDistances", "[", 
                 RowBox[{"Length", "[", "ps", "]"}], "]"}], "]"}], "]"}]}], 
             "}"}]}], "}"}], ",", 
          RowBox[{"Spacings", "\[Rule]", 
           RowBox[{"{", 
            RowBox[{"1", ",", "1"}], "}"}]}], ",", 
          RowBox[{"Dividers", "\[Rule]", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"False", ",", "True"}], "}"}], ",", 
             RowBox[{"{", 
              RowBox[{"False", ",", "True"}], "}"}]}], "}"}]}]}], "]"}], ",", 
        RowBox[{"Show", "[", 
         RowBox[{
          RowBox[{"Histogram", "[", 
           RowBox[{
            RowBox[{"TakeSmallest", "[", 
             RowBox[{
              RowBox[{
              "Last", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], ",", 
              RowBox[{"Ceiling", "[", 
               RowBox[{"0.9", 
                RowBox[{"Length", "[", 
                 RowBox[{
                 "Last", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
                 "]"}]}], "]"}]}], "]"}], ",", "Automatic", ",", 
            "\"\<PDF\>\""}], "]"}], ",", 
          RowBox[{"Plot", "[", 
           RowBox[{
            RowBox[{"PDF", "[", 
             RowBox[{
              RowBox[{"expectedMahalanobisDistances", "[", 
               RowBox[{"Length", "[", "ps", "]"}], "]"}], ",", "x"}], "]"}], 
            ",", 
            RowBox[{"{", 
             RowBox[{"x", ",", "0", ",", 
              RowBox[{"Max", "[", 
               RowBox[{
               "Last", "[", "maxLikelihoodAndMahalanobisDistance", "]"}], 
               "]"}]}], "}"}], ",", 
            RowBox[{"PlotRange", "\[Rule]", "All"}]}], "]"}], ",", 
          RowBox[{"ImageSize", "\[Rule]", "200"}]}], "]"}]}], "}"}], ",", 
      RowBox[{"Alignment", "\[Rule]", "Center"}], ",", 
      RowBox[{"Spacings", "\[Rule]", "1"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.738389250244948*^9, 3.738389292590725*^9}, {
   3.738394873030875*^9, 3.738394895756098*^9}, {3.7384207952171774`*^9, 
   3.738420799665144*^9}, {3.7384210880321407`*^9, 3.7384211257521753`*^9}, {
   3.7384290408234367`*^9, 3.7384291157842646`*^9}, {3.7384304512515182`*^9, 
   3.738430479453521*^9}, {3.7384305182765503`*^9, 3.7384305264235163`*^9}, {
   3.7384306136015186`*^9, 3.7384306157265167`*^9}, {3.7384736683023643`*^9, 
   3.7384736752471075`*^9}, {3.7384737990512295`*^9, 
   3.7384738295918355`*^9}, {3.7384740452708583`*^9, 3.738474046692028*^9}, 
   3.7384754284433317`*^9, {3.7384761930756364`*^9, 3.7384762117800074`*^9}, {
   3.7385694475461183`*^9, 3.7385694489367375`*^9}, {3.738570398145123*^9, 
   3.7385704002891254`*^9}, {3.7385774303965635`*^9, 3.738577609193818*^9}, {
   3.738577901893123*^9, 3.7385779503241067`*^9}, {3.7385780311991234`*^9, 
   3.7385780339313383`*^9}, {3.7385781699811873`*^9, 3.738578182916932*^9}, {
   3.7385795961233687`*^9, 3.7385796155608487`*^9}, {3.738582455823017*^9, 
   3.738582457307535*^9}, {3.738583441389027*^9, 3.738583441607773*^9}, 
   3.7385835093525696`*^9, {3.738583708094412*^9, 3.738583711839909*^9}, 
   3.7385849774580407`*^9, {3.7385851627339315`*^9, 3.738585192265172*^9}, {
   3.739178110495305*^9, 3.739178169182821*^9}, {3.7391783998548126`*^9, 
   3.739178450651673*^9}, {3.7391785225421762`*^9, 3.739178654042322*^9}, {
   3.739178769917228*^9, 3.739178874839075*^9}, {3.7391789521203475`*^9, 
   3.739178989401593*^9}, {3.7392836907269115`*^9, 3.7392837312868648`*^9}, {
   3.73928390381609*^9, 3.7392839258061438`*^9}},
 CellLabel->"In[57]:=",ExpressionUUID->"e1eec1d9-bc3b-4f5d-87d4-a54710ece320"],

Cell[BoxData[
 RowBox[{
  RowBox[{"visualiseEstimationGrid", "[", 
   RowBox[{
   "l_", ",", "generationTypes_", ",", "modelTypes_", ",", "n_", ",", "pMap_",
     ",", "t_", ",", "equations_", ",", "counts_", ",", "countsList_", ",", 
    "singleAnalysis_", ",", "multipleAnalysis_"}], "]"}], ":=", 
  RowBox[{"Which", "[", 
   RowBox[{
    RowBox[{
     RowBox[{
      RowBox[{"Length", "[", "generationTypes", "]"}], "<", "1"}], "||", 
     RowBox[{
      RowBox[{"Length", "[", "modelTypes", "]"}], "<", "1"}]}], ",", 
    "\"\<Model undetermined: please choose at least one generation and model \
type.\>\"", ",", 
    RowBox[{
     RowBox[{
      RowBox[{"Length", "[", "generationTypes", "]"}], ">=", 
      RowBox[{"censusGraphCounts", "[", "l", "]"}]}], "||", 
     RowBox[{
      RowBox[{"Length", "[", "modelTypes", "]"}], ">=", 
      RowBox[{"censusGraphCounts", "[", "l", "]"}]}]}], ",", 
    "\"\<Model overfit: please choose fewer generation and model types, or \
select a higher subgraph size.\>\"", ",", "True", ",", 
    RowBox[{"Quiet", "[", 
     RowBox[{
      RowBox[{"With", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"pList", "=", 
          RowBox[{"Map", "[", 
           RowBox[{
            RowBox[{
             RowBox[{"\"\<p\>\"", "<>", 
              RowBox[{"StringTake", "[", 
               RowBox[{"#", ",", "1"}], "]"}]}], "&"}], ",", 
            RowBox[{"Keys", "[", "pMap", "]"}]}], "]"}]}], "}"}], ",", 
        RowBox[{"With", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"equationList", "=", 
            RowBox[{"Map", "[", 
             RowBox[{
              RowBox[{
               RowBox[{"#", "[", 
                RowBox[{"\"\<n\>\"", ",", "pList"}], "]"}], "&"}], ",", 
              RowBox[{"Values", "[", 
               RowBox[{
                RowBox[{"censusEquations", "[", "l", "]"}], "[", 
                RowBox[{"keySort", "[", 
                 RowBox[{"generationTypes", ",", "subgraphVertexCounts"}], 
                 "]"}], "]"}], "]"}]}], "]"}]}], "}"}], ",", 
          RowBox[{"Grid", "[", 
           RowBox[{
            RowBox[{"{", 
             RowBox[{
              RowBox[{"Join", "[", 
               RowBox[{
                RowBox[{"{", "\"\<Subgraph\>\"", "}"}], ",", 
                RowBox[{"Map", "[", 
                 RowBox[{
                  RowBox[{
                   RowBox[{"Graph", "[", 
                    RowBox[{
                    RowBox[{"Range", "[", "l", "]"}], ",", "#", ",", 
                    RowBox[{
                    "GraphLayout", "\[Rule]", "\"\<CircularEmbedding\>\""}]}],
                     "]"}], "&"}], ",", 
                  RowBox[{"generateCensusGraphs", "[", "l", "]"}]}], "]"}], 
                ",", 
                RowBox[{"{", "\"\<Total\>\"", "}"}]}], "]"}], ",", 
              RowBox[{"Join", "[", 
               RowBox[{
                RowBox[{"{", 
                 RowBox[{"Row", "[", 
                  RowBox[{"generationTypes", ",", "\"\<&\>\""}], "]"}], "}"}],
                 ",", "equationList", ",", 
                RowBox[{"{", 
                 RowBox[{"Simplify", "[", 
                  RowBox[{"Total", "[", "equationList", "]"}], "]"}], "}"}]}],
                "]"}], ",", 
              RowBox[{"Join", "[", 
               RowBox[{
                RowBox[{"{", "\"\<Expected\>\"", "}"}], ",", 
                RowBox[{"Map", "[", 
                 RowBox[{
                  RowBox[{
                   RowBox[{"#", "[", 
                    RowBox[{"n", ",", 
                    RowBox[{"Values", "[", "pMap", "]"}]}], "]"}], "&"}], ",", 
                  RowBox[{"Values", "[", 
                   RowBox[{
                    RowBox[{"censusExpectedValue", "[", "l", "]"}], "[", 
                    RowBox[{"keySort", "[", 
                    RowBox[{"generationTypes", ",", "subgraphVertexCounts"}], 
                    "]"}], "]"}], "]"}]}], "]"}], ",", 
                RowBox[{"{", 
                 RowBox[{"Binomial", "[", 
                  RowBox[{"n", ",", "l"}], "]"}], "}"}]}], "]"}], ",", 
              RowBox[{"Join", "[", 
               RowBox[{
                RowBox[{"{", "\"\<Single\>\"", "}"}], ",", "counts", ",", 
                RowBox[{"{", "singleAnalysis", "}"}]}], "]"}], ",", 
              RowBox[{"Quiet", "[", 
               RowBox[{"Join", "[", 
                RowBox[{
                 RowBox[{"{", "\"\<Multiple\>\"", "}"}], ",", 
                 RowBox[{"MapThread", "[", 
                  RowBox[{
                   RowBox[{
                    RowBox[{"visualiseHistogram", "[", 
                    RowBox[{"l", ",", "n", ",", "#1", ",", "#2"}], "]"}], 
                    "&"}], ",", 
                   RowBox[{"{", 
                    RowBox[{
                    RowBox[{"Map", "[", 
                    RowBox[{
                    RowBox[{
                    RowBox[{"#", "[", 
                    RowBox[{"n", ",", 
                    RowBox[{"Values", "[", "pMap", "]"}]}], "]"}], "&"}], ",", 
                    RowBox[{"Values", "[", 
                    RowBox[{
                    RowBox[{"equations", "[", "l", "]"}], "[", 
                    RowBox[{"Keys", "[", "pMap", "]"}], "]"}], "]"}]}], "]"}],
                     ",", 
                    RowBox[{"Transpose", "[", "countsList", "]"}]}], "}"}]}], 
                  "]"}], ",", 
                 RowBox[{"{", "multipleAnalysis", "}"}]}], "]"}], "]"}]}], 
             "}"}], ",", 
            RowBox[{"Frame", "\[Rule]", "All"}], ",", 
            RowBox[{"Spacings", "\[Rule]", 
             RowBox[{"{", 
              RowBox[{"2", ",", "3"}], "}"}]}]}], "]"}]}], "]"}]}], "]"}], 
      ",", 
      RowBox[{"{", 
       StyleBox[
        RowBox[{"Part", "::", "partw"}], "MessageName"], "}"}]}], "]"}]}], 
   "]"}]}]], "Input",
 CellChangeTimes->{{3.7353638791902122`*^9, 3.735363929038431*^9}, {
   3.7353642000001264`*^9, 3.7353642253423853`*^9}, {3.7353657558960857`*^9, 
   3.73536575891171*^9}, {3.7353662639652634`*^9, 3.7353662929611673`*^9}, {
   3.7353699039426775`*^9, 3.7353699166042128`*^9}, {3.7353699765952444`*^9, 
   3.735369978704611*^9}, {3.7353700500990295`*^9, 3.735370059559373*^9}, {
   3.7353706530967855`*^9, 3.735370697438306*^9}, {3.735370743115124*^9, 
   3.7353707820411663`*^9}, {3.7353711099580517`*^9, 
   3.7353711514209027`*^9}, {3.7353717637228584`*^9, 
   3.7353717857178907`*^9}, {3.7353727103042307`*^9, 
   3.7353727109916983`*^9}, {3.735372862894586*^9, 3.735372863300972*^9}, {
   3.7353729018695116`*^9, 3.735373064065915*^9}, {3.735373105396386*^9, 
   3.735373117079811*^9}, {3.7353731542917604`*^9, 3.735373157807247*^9}, {
   3.735373200963481*^9, 3.7353732347684665`*^9}, {3.7353732730746574`*^9, 
   3.7353734049276876`*^9}, {3.7353737002015996`*^9, 3.735373705982852*^9}, {
   3.735373786058122*^9, 3.7353737867299967`*^9}, 3.7353738679109898`*^9, {
   3.7353739020204144`*^9, 3.7353739021768055`*^9}, {3.735373954819997*^9, 
   3.73537398309903*^9}, {3.7353741060858326`*^9, 3.7353742267456656`*^9}, {
   3.7353743132726974`*^9, 3.7353743723720207`*^9}, {3.7353745209105296`*^9, 
   3.7353745595592346`*^9}, {3.735374844942629*^9, 3.735374924738258*^9}, {
   3.735374961644905*^9, 3.735374977431453*^9}, {3.7353750254842815`*^9, 
   3.73537504170289*^9}, {3.735463137879011*^9, 3.7354631773946323`*^9}, {
   3.7354634045353374`*^9, 3.735463470269734*^9}, {3.735463566035408*^9, 
   3.735463569457288*^9}, 3.7354636394729147`*^9, {3.735463673801078*^9, 
   3.7354636804260707`*^9}, {3.7354637606136017`*^9, 3.735463764894852*^9}, {
   3.7354638525198703`*^9, 3.7354638625041447`*^9}, {3.7354643292747583`*^9, 
   3.7354643377121005`*^9}, {3.7354643691183634`*^9, 
   3.7354643861027436`*^9}, {3.735464452696651*^9, 3.735464496806055*^9}, 
   3.7354670476892505`*^9, 3.735535919727089*^9, {3.7360537171856585`*^9, 
   3.7360537320728645`*^9}, {3.7371828612911186`*^9, 
   3.7371829300419865`*^9}, {3.7371829999646177`*^9, 3.737183001652116*^9}, {
   3.7371859807601137`*^9, 3.7371860685813265`*^9}, {3.7371889066845484`*^9, 
   3.737188947100439*^9}, {3.7371898737315784`*^9, 3.737189881700328*^9}, {
   3.7371900920822296`*^9, 3.7371901007542505`*^9}, {3.7377088462343326`*^9, 
   3.7377088477187157`*^9}, {3.7377088974688396`*^9, 
   3.7377089314532146`*^9}, {3.7383868448875384`*^9, 3.738386874232571*^9}, {
   3.738387647412939*^9, 3.7383876517098117`*^9}, {3.7383886299177923`*^9, 
   3.7383886309646797`*^9}, {3.7383886795911655`*^9, 
   3.7383887001611853`*^9}, {3.7383891390056844`*^9, 
   3.7383891397400546`*^9}, {3.739287399168748*^9, 3.7392874020242186`*^9}, {
   3.7393390404455824`*^9, 3.739339102898834*^9}, {3.739604254112118*^9, 
   3.7396043538958015`*^9}, {3.7396044151708574`*^9, 3.739604418358203*^9}, {
   3.739604453796686*^9, 3.7396044572496758`*^9}, 3.739604557402635*^9},
 CellLabel->"In[58]:=",ExpressionUUID->"63bda061-98dd-4da4-9aa7-38125db5b51e"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Examples", "Subsection",
 CellChangeTimes->{{3.7313136105953646`*^9, 3.7313136348285203`*^9}, 
   3.7353639674740095`*^9, {3.736572676118946*^9, 3.736572678040842*^9}, {
   3.7382206348845997`*^9, 3.7382206417753263`*^9}, {3.73822085405647*^9, 
   3.738220854603479*^9}, 3.738389089324147*^9, 
   3.7396154222264957`*^9},ExpressionUUID->"4325f48d-1a27-42d4-82db-\
e09bb7008434"],

Cell["\<\
The example below contains the probabilities of observing any of the possible \
census types for various generation models. It also contain a button to \
generate a single graph and its census counts, as well as one to generate \
multiple graphs and counts. Both these simulations can be analysed using the \
maximum likelihood method.\
\>", "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, {
  3.7362379812980385`*^9, 3.7362379901979485`*^9}, {3.7362416304714537`*^9, 
  3.7362416807710543`*^9}, {3.7362417329754915`*^9, 3.7362417373495755`*^9}, {
  3.7362417789368477`*^9, 3.7362418297692933`*^9}, {3.7395998993668447`*^9, 
  3.739599920550763*^9}, {3.7396113487446823`*^9, 3.7396113489320364`*^9}, {
  3.73961145371553*^9, 3.739611454090527*^9}, {3.739612907423685*^9, 
  3.7396129569932127`*^9}, {3.7396164113611307`*^9, 3.739616421048768*^9}, {
  3.739679903137769*^9, 
  3.7396799048252687`*^9}},ExpressionUUID->"75d9e694-79d0-4d87-90ed-\
4bdd80a32aa2"],

Cell[BoxData[
 RowBox[{"With", "[", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"outerControls", "=", 
     RowBox[{"Grid", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"l", ",", "2", ",", "\"\<Subgraph size\>\""}], "}"}], 
             ",", "censusSizes"}], "}"}], "]"}], ",", "\"\<\>\"", ",", 
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"generationTypes", ",", 
               RowBox[{"{", 
                RowBox[{"First", "[", 
                 RowBox[{"Keys", "[", "subgraphVertexCounts", "]"}], "]"}], 
                "}"}], ",", "\"\<Generation type(s)\>\""}], "}"}], ",", 
             RowBox[{"Keys", "[", "subgraphVertexCounts", "]"}], ",", 
             RowBox[{"ControlType", "\[Rule]", "TogglerBar"}], ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Vertical\>\""}]}], "}"}], 
           "]"}], ",", 
          RowBox[{"Control", "[", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"{", 
              RowBox[{"modelTypes", ",", 
               RowBox[{"{", 
                RowBox[{"First", "[", 
                 RowBox[{"Keys", "[", "subgraphVertexCounts", "]"}], "]"}], 
                "}"}], ",", "\"\<Model type(s)\>\""}], "}"}], ",", 
             RowBox[{"Keys", "[", "subgraphVertexCounts", "]"}], ",", 
             RowBox[{"ControlType", "\[Rule]", "TogglerBar"}], ",", 
             RowBox[{"Appearance", "\[Rule]", "\"\<Vertical\>\""}]}], "}"}], 
           "]"}]}], "}"}], "}"}], ",", 
       RowBox[{"Spacings", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{"1", ",", "1"}], "}"}]}]}], "]"}]}], "}"}], ",", 
   RowBox[{"Manipulate", "[", 
    RowBox[{
     RowBox[{"With", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"pMap", "=", 
         RowBox[{"Map", "[", 
          RowBox[{
           RowBox[{
            RowBox[{"#", "->", 
             RowBox[{"Symbol", "[", 
              RowBox[{"\"\<p\>\"", "<>", 
               RowBox[{"StringTake", "[", 
                RowBox[{"#", ",", "1"}], "]"}]}], "]"}]}], "&"}], ",", 
           RowBox[{"keySort", "[", 
            RowBox[{"generationTypes", ",", "subgraphVertexCounts"}], "]"}]}],
           "]"}]}], "}"}], ",", 
       RowBox[{"With", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{"innerControls", "=", 
           RowBox[{"Grid", "[", 
            RowBox[{"Join", "[", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{
                RowBox[{"{", 
                 RowBox[{"\"\<General\>\"", ",", 
                  RowBox[{"Control", "[", 
                   RowBox[{"{", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"n", ",", "50"}], "}"}], ",", "2", ",", "200", 
                    ",", "1", ",", 
                    RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], 
                    "}"}], "]"}], ",", 
                  RowBox[{"Control", "[", 
                   RowBox[{"{", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"t", ",", "100"}], "}"}], ",", "2", ",", "400", 
                    ",", "1", ",", 
                    RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], 
                    "}"}], "]"}]}], "}"}], ",", 
                RowBox[{"{", 
                 RowBox[{"\"\<Single\>\"", ",", " ", 
                  RowBox[{"Button", "[", 
                   RowBox[{"\"\<Generate\>\"", ",", 
                    RowBox[{"{", 
                    RowBox[{"counts", "=", 
                    RowBox[{"Values", "[", 
                    RowBox[{"countCensusGraphs", "[", 
                    RowBox[{"l", ",", "n", ",", 
                    RowBox[{"generateGraphList", "[", 
                    RowBox[{
                    "subgraphVertexCounts", ",", "subgraphEdgeMaps", ",", "n",
                     ",", 
                    RowBox[{"Association", "[", "pMap", "]"}]}], "]"}]}], 
                    "]"}], "]"}]}], "}"}]}], "]"}], ",", 
                  RowBox[{"Button", "[", 
                   RowBox[{"\"\<Analyse\>\"", ",", 
                    RowBox[{"{", 
                    RowBox[{"singleAnalysis", "=", 
                    RowBox[{"visualiseLikelihood", "[", 
                    RowBox[{"l", ",", 
                    RowBox[{"Total", "[", 
                    RowBox[{"Values", "[", 
                    RowBox[{"subgraphVertexCounts", "[", 
                    RowBox[{"[", "modelTypes", "]"}], "]"}], "]"}], "]"}], 
                    ",", "n", ",", "counts", ",", 
                    RowBox[{
                    RowBox[{"censusEquations", "[", "l", "]"}], "[", 
                    RowBox[{"keySort", "[", 
                    RowBox[{"modelTypes", ",", "subgraphVertexCounts"}], 
                    "]"}], "]"}], ",", 
                    RowBox[{
                    RowBox[{"censusLikelihoods", "[", "l", "]"}], "[", 
                    RowBox[{"keySort", "[", 
                    RowBox[{"modelTypes", ",", "subgraphVertexCounts"}], 
                    "]"}], "]"}]}], "]"}]}], "}"}]}], "]"}]}], "}"}], ",", 
                RowBox[{"{", 
                 RowBox[{"\"\<Multiple\>\"", ",", 
                  RowBox[{"Button", "[", 
                   RowBox[{"\"\<Generate\>\"", ",", 
                    RowBox[{"{", 
                    RowBox[{"countsList", "=", 
                    RowBox[{"Table", "[", 
                    RowBox[{
                    RowBox[{"Values", "[", 
                    RowBox[{"countCensusGraphs", "[", 
                    RowBox[{"l", ",", "n", ",", 
                    RowBox[{"generateGraphList", "[", 
                    RowBox[{
                    "subgraphVertexCounts", ",", "subgraphEdgeMaps", ",", "n",
                     ",", 
                    RowBox[{"Association", "[", "pMap", "]"}]}], "]"}]}], 
                    "]"}], "]"}], ",", 
                    RowBox[{"{", 
                    RowBox[{"i", ",", "1", ",", "t"}], "}"}]}], "]"}]}], 
                    "}"}]}], "]"}], ",", 
                  RowBox[{"Button", "[", 
                   RowBox[{"\"\<Analyse\>\"", ",", 
                    RowBox[{"{", 
                    RowBox[{"multipleAnalysis", "=", 
                    RowBox[{"visualiseMahalanobisDistance", "[", 
                    RowBox[{"l", ",", 
                    RowBox[{"Total", "[", 
                    RowBox[{"Values", "[", 
                    RowBox[{"subgraphEdgeCounts", "[", 
                    RowBox[{"[", "modelTypes", "]"}], "]"}], "]"}], "]"}], 
                    ",", "n", ",", 
                    RowBox[{
                    RowBox[{"censusEquations", "[", "l", "]"}], "[", 
                    RowBox[{"keySort", "[", 
                    RowBox[{"modelTypes", ",", "subgraphVertexCounts"}], 
                    "]"}], "]"}], ",", 
                    RowBox[{
                    RowBox[{"censusLikelihoods", "[", "l", "]"}], "[", 
                    RowBox[{"keySort", "[", 
                    RowBox[{"generationTypes", ",", "subgraphVertexCounts"}], 
                    "]"}], "]"}], ",", "countsList", ",", 
                    RowBox[{"pMap", "[", 
                    RowBox[{"[", 
                    RowBox[{"All", ",", "2"}], "]"}], "]"}]}], "]"}]}], 
                    "}"}]}], "]"}]}], "}"}]}], "}"}], ",", 
              RowBox[{"KeyValueMap", "[", 
               RowBox[{
                RowBox[{
                 RowBox[{"{", 
                  RowBox[{"#1", ",", 
                   RowBox[{"Control", "[", 
                    RowBox[{"{", 
                    RowBox[{
                    RowBox[{"{", 
                    RowBox[{"#2", ",", "0.04"}], "}"}], ",", "0", ",", "0.1", 
                    ",", "0.01", ",", 
                    RowBox[{"Appearance", "\[Rule]", "\"\<Open\>\""}]}], 
                    "}"}], "]"}], ",", "\"\<\>\""}], "}"}], "&"}], ",", 
                RowBox[{"Association", "[", "pMap", "]"}]}], "]"}]}], "]"}], 
            "]"}]}], "}"}], ",", 
         RowBox[{"DynamicModule", "[", 
          RowBox[{
           RowBox[{"{", 
            RowBox[{
             RowBox[{"counts", "=", 
              RowBox[{"ConstantArray", "[", 
               RowBox[{"0", ",", 
                RowBox[{"censusGraphCounts", "[", "l", "]"}]}], "]"}]}], ",", 
             RowBox[{"countsList", "=", 
              RowBox[{"ConstantArray", "[", 
               RowBox[{
                RowBox[{"ConstantArray", "[", 
                 RowBox[{"0", ",", 
                  RowBox[{"censusGraphCounts", "[", "l", "]"}]}], "]"}], ",", 
                "2"}], "]"}]}], ",", 
             RowBox[{"singleAnalysis", "=", "\"\<Run Sim.\>\""}], ",", 
             RowBox[{"multipleAnalysis", "=", "\"\<Run Sim.\>\""}]}], "}"}], 
           ",", 
           RowBox[{"Manipulate", "[", 
            RowBox[{
             RowBox[{"visualiseEstimationGrid", "[", 
              RowBox[{
              "l", ",", "generationTypes", ",", "modelTypes", ",", "n", ",", 
               RowBox[{"Association", "[", "pMap", "]"}], ",", "t", ",", 
               "censusEquations", ",", "counts", ",", "countsList", ",", 
               "singleAnalysis", ",", "multipleAnalysis"}], "]"}], ",", 
             "innerControls"}], "]"}]}], "]"}]}], "]"}]}], "]"}], ",", 
     "outerControls"}], "]"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.735322888583871*^9, 3.735322888583871*^9}, {
   3.735323126301075*^9, 3.7353231518068266`*^9}, {3.735323219834231*^9, 
   3.7353232352143307`*^9}, {3.7353234422747583`*^9, 
   3.7353235924150906`*^9}, {3.7353564638909235`*^9, 3.735356508115877*^9}, {
   3.735356538362483*^9, 3.7353565610031266`*^9}, {3.7353566307686305`*^9, 
   3.7353566959405107`*^9}, {3.735356728018639*^9, 3.73535674626877*^9}, 
   3.7353637175991626`*^9, {3.735363780273616*^9, 3.7353638378942337`*^9}, {
   3.7353638704244156`*^9, 3.735363895868853*^9}, {3.7353639455079594`*^9, 
   3.7353639457579575`*^9}, {3.7353641789105463`*^9, 
   3.7353642278423843`*^9}, {3.7353655590266337`*^9, 3.735365620025198*^9}, {
   3.7353660184518967`*^9, 3.7353660753163013`*^9}, {3.7353662007864275`*^9, 
   3.735366261481042*^9}, {3.7353662959610357`*^9, 3.735366313957903*^9}, {
   3.735366356372202*^9, 3.7353663934271765`*^9}, {3.735366427488448*^9, 
   3.7353664719750957`*^9}, 3.7353668374817257`*^9, {3.73537166661331*^9, 
   3.7353717375593634`*^9}, {3.7353718648556185`*^9, 3.735371935730049*^9}, {
   3.7353719693106127`*^9, 3.735371973253292*^9}, {3.735372011144622*^9, 
   3.73537204345417*^9}, {3.7353721277083063`*^9, 3.7353722050238204`*^9}, {
   3.7353722669107733`*^9, 3.735372309715757*^9}, {3.7353724154083652`*^9, 
   3.7353724492831187`*^9}, {3.735372648723605*^9, 3.735372672989038*^9}, {
   3.735374436976554*^9, 3.7353744534298296`*^9}, {3.7353752762155848`*^9, 
   3.7353753120001764`*^9}, {3.735375371625534*^9, 3.735375379484766*^9}, {
   3.735375501582329*^9, 3.7353755545542345`*^9}, {3.735375852598383*^9, 
   3.735375857738867*^9}, {3.735375966457831*^9, 3.7353759922541666`*^9}, 
   3.7353760411203566`*^9, {3.73537615884943*^9, 3.735376170022069*^9}, {
   3.7354628113401732`*^9, 3.735463059855729*^9}, {3.73546310656652*^9, 
   3.735463109128995*^9}, {3.7354631828477793`*^9, 3.735463193035184*^9}, {
   3.7354632354882684`*^9, 3.7354633053790646`*^9}, {3.73546335917584*^9, 
   3.735463401613324*^9}, {3.7354635360822725`*^9, 3.7354635502228928`*^9}, {
   3.735463776410326*^9, 3.735463844785349*^9}, {3.7354640353710966`*^9, 
   3.7354640425898266`*^9}, {3.735464116480486*^9, 3.7354642026055093`*^9}, {
   3.7354644426652627`*^9, 3.735464511899809*^9}, {3.7354670277683463`*^9, 
   3.735467047111126*^9}, 3.7354670943372045`*^9, {3.735535794912949*^9, 
   3.73553580206466*^9}, 3.7371881920959735`*^9, {3.7371882945042024`*^9, 
   3.7371883118452015`*^9}, {3.7371883433041997`*^9, 
   3.7371883748852005`*^9}, {3.737188763526939*^9, 3.737188801429736*^9}, {
   3.7371894428735676`*^9, 3.737189443061073*^9}, {3.73745854027715*^9, 
   3.7374585623396397`*^9}, {3.7374587319955263`*^9, 
   3.7374587980025363`*^9}, {3.737458841300512*^9, 3.7374588472536373`*^9}, {
   3.737459368311746*^9, 3.7374594210230713`*^9}, {3.737459461274753*^9, 
   3.737459495860478*^9}, {3.737459763216364*^9, 3.737459764200744*^9}, {
   3.7374649018730164`*^9, 3.7374649099288163`*^9}, {3.7377059757494297`*^9, 
   3.737706007436827*^9}, {3.73770604965567*^9, 3.737706060171311*^9}, 
   3.737706096280673*^9, {3.7377062992053385`*^9, 3.7377062993357944`*^9}, 
   3.7381393565526066`*^9, {3.738140048107955*^9, 3.7381400481129513`*^9}, {
   3.7381416897126045`*^9, 3.7381416905574493`*^9}, {3.738141740112586*^9, 
   3.7381417401375937`*^9}, {3.7383868986235266`*^9, 3.738386920230403*^9}, {
   3.7383876616343174`*^9, 3.7383876825882797`*^9}, {3.73838783565596*^9, 
   3.7383878439002314`*^9}, {3.7383886348995457`*^9, 3.7383886364933*^9}, 
   3.7383893008875628`*^9, 3.738394906599958*^9, 3.73842088366514*^9, {
   3.738477155898015*^9, 3.7384771837046595`*^9}, {3.7385680296334877`*^9, 
   3.7385680296334877`*^9}, {3.7396053445998993`*^9, 3.7396053511331725`*^9}},
 CellLabel->"In[59]:=",ExpressionUUID->"e99d5a38-4268-4fca-a66c-ab47136c9287"],

Cell[TextData[{
 "Future work should extend the list of possible subgraphs, deal with the \
correlations within the census, develop an ",
 StyleBox["R",
  FontSlant->"Italic"],
 "-package and apply the model to real-world data."
}], "Text",
 CellChangeTimes->{{3.7313961183691397`*^9, 3.7313961250085583`*^9}, 
   3.736238005783177*^9, {3.7362418466115313`*^9, 
   3.7362418513493767`*^9}},ExpressionUUID->"be4af1aa-7901-4ff7-9e99-\
a1adbc9da5b7"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["References", "Section",
 CellChangeTimes->{{3.7361622603928947`*^9, 
  3.7361622728304005`*^9}},ExpressionUUID->"1dd09355-1f20-4db3-a5df-\
dbc825bdc30d"],

Cell["\<\
[1] F. W. Takes and E. M. Heemskerk, \"Centrality in the global network of \
corporate control,\" Social Network Analysis and Mining, vol. 6, pp. \
1\[Dash]18, 2016.
[2] M. Fennema and E. M. Heemskerk, \"When theory meets methods: the \
naissance of computer assisted corporate interlock research,\" Global \
Networks, vol. 1, pp. 81\[Dash]104, 2018.
[3] C. R. Shalizi and A. Rinaldo, \"Consistency under sampling of exponential \
random graph models,\" The Annals of Statistics, vol. 41, pp. 508\[Dash]535, \
2013.
[4] S. Chatterjee and P. Diaconis, \"Estimating and understanding exponential \
random graph models,\" The Annals of Statistics, vol. 41, pp. \
2428\[Dash]2461, 2013.
[5] S. Bhamidi, G. Bresler, and A.Sly, \"Mixing time of exponential random \
graphs,\" The Annals of Applied Probability, vol. 21, pp. 2146\[Dash]2170, \
2011.
[6] A. G. Chandrasekhar and M. O. Jackson, \"Tractable and consistent random \
graph models,\" ArXiv, 2014. [Online]. Available: \
https://arxiv.org/abs/1210.7375.
[7] A. G. Chandrasekhar and M. O. Jackson, \"A network formation model based \
on subgraphs,\" ArXiv, 2016. [Online]. Available: \
https://arxiv.org/abs/1611.07658.
[8] A. G. Chandrasekhar, \"Econometrics of network formation,\" in The Oxford \
Handbook of the Economics of Networks, Y. Bramoulle, A. Galeotti, and B. \
Rogers, Eds. Oxford University Press, 2016.
[9] J. A. Davis and S. Leinhardt, \"The structure of positive interpersonal \
relations in small groups,\" in Sociological Theory in Progress, J. Berger, \
M. Zelditch, and B. Anderson, Eds. Houghton-Mifflin, 1972.
[10] P. W. Holland and S. Leinhardt, \"A method for detecting structure in \
sociometric data,\" American Journal of Sociology, vol. 76, pp. \
492\[Dash]513, 1970.
[11] P. W. Holland and S. Leinhardt, \"Local structure in social networks,\" \
Sociological Methodology, vol. 7, pp. 1\[Dash]45, 1976.
[12] E. W. Weisstein, \"Degree Sequence,\" MathWorld-A Wolfram Web Resource, \
2018. [Online]. Available: http://mathworld.wolfram.com/DegreeSequence.html.
[13] S. Chib and E. Greenberg, \"Understanding the metropolis-hastings \
algorithm,\" The American Statistician, vol. 49, pp. 327\[Dash]335, 1995.\
\>", "Text",
 CellChangeTimes->{{3.7361622667991495`*^9, 3.736162278596022*^9}, {
   3.7361623089866533`*^9, 3.736162460860938*^9}, {3.736237670936941*^9, 
   3.736237734291402*^9}, 3.736237782605814*^9, {3.7370868661510353`*^9, 
   3.7370869654141464`*^9}, 3.7372103008792934`*^9, {3.7395945060194197`*^9, 
   3.7395945138788033`*^9}, {3.739598545259794*^9, 3.7395986613850346`*^9}, {
   3.739610881545342*^9, 
   3.7396110026169105`*^9}},ExpressionUUID->"8c9ba590-619d-49cd-a50d-\
978878485bfa"]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1920, 1007},
WindowMargins->{{-8, Automatic}, {Automatic, -8}},
PrintingCopies->1,
PrintingPageRange->{1, 32000},
PrintingOptions->{"Magnification"->1.,
"PaperOrientation"->"Landscape",
"PaperSize"->{841.92, 595.3199999999999},
"PrintingMargins"->28.346456999999997`},
FrontEndVersion->"11.3 for Microsoft Windows (64-bit) (March 6, 2018)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1510, 35, 329, 6, 96, "Title",ExpressionUUID->"8f6ba89d-3c28-4ee5-949d-393fa35e6fce"],
Cell[1842, 43, 436, 8, 72, "Subsubtitle",ExpressionUUID->"c185089a-75bc-47b7-98eb-f4ae90efd4d9"],
Cell[CellGroupData[{
Cell[2303, 55, 214, 4, 67, "Section",ExpressionUUID->"7128cf08-7110-4f96-975b-dad6a102c09f"],
Cell[2520, 61, 1354, 22, 166, "Text",ExpressionUUID->"2b412d49-4302-46f2-a481-f763a12c88af"],
Cell[CellGroupData[{
Cell[3899, 87, 338, 5, 53, "Subsection",ExpressionUUID->"71cb8f82-5049-405a-85bc-4a1dfe6da245"],
Cell[4240, 94, 1048, 22, 56, "Text",ExpressionUUID->"203a8a02-ffbf-4e71-b9f1-903d8fdf96c9"],
Cell[5291, 118, 524, 8, 28, "Input",ExpressionUUID->"f5be415c-7994-41ae-99ef-bad344b357cd"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[5864, 132, 259, 4, 67, "Section",ExpressionUUID->"ffb55aa8-dbfc-4cdf-952b-e33f8d6c0061"],
Cell[6126, 138, 1552, 43, 56, "Text",ExpressionUUID->"41a58947-fa06-4943-acc6-fc06a6fe9048"],
Cell[CellGroupData[{
Cell[7703, 185, 386, 6, 53, "Subsection",ExpressionUUID->"4462b8c4-0813-41eb-813d-ad1622060fed"],
Cell[8092, 193, 311, 7, 34, "Text",ExpressionUUID->"5cbdcff5-5ead-4421-bc52-dc6065705985"],
Cell[8406, 202, 1814, 40, 28, "Input",ExpressionUUID->"7265e45e-5b74-4dda-bbfc-d362f37d9ee6"]
}, Open  ]],
Cell[CellGroupData[{
Cell[10257, 247, 459, 7, 53, "Subsection",ExpressionUUID->"d1677566-2ef4-4d9a-bda6-34cb1b4aea21"],
Cell[10719, 256, 1138, 20, 56, "Text",ExpressionUUID->"6b13224d-76cf-4ba2-917f-cf50a5fbf396"],
Cell[11860, 278, 1380, 33, 28, "Input",ExpressionUUID->"b3f1e037-ff23-4115-ac94-09008916dfe2"],
Cell[13243, 313, 441, 11, 28, "Input",ExpressionUUID->"a9616a0b-2e52-4ce6-bc2c-402ad7f8a202"],
Cell[13687, 326, 1446, 29, 28, "Input",ExpressionUUID->"e12821af-4f69-4eda-b19e-f6fb6ccb1489"],
Cell[15136, 357, 1027, 20, 28, "Input",ExpressionUUID->"c2316eec-5e18-4751-8f83-d2b8ee8ac5c4"],
Cell[16166, 379, 807, 18, 28, "Input",ExpressionUUID->"1e8b3f1e-91d5-4712-99d1-82e4156f30a6"]
}, Open  ]],
Cell[CellGroupData[{
Cell[17010, 402, 541, 8, 53, "Subsection",ExpressionUUID->"0aa8c034-c27e-40fd-865c-dfb3ba6bc78c"],
Cell[17554, 412, 464, 9, 34, "Text",ExpressionUUID->"855f78c9-86ee-4a90-bafd-df92fbaf9656"],
Cell[18021, 423, 571, 11, 28, "Input",ExpressionUUID->"d61edb66-53b7-413e-92f0-25c2428395d6"],
Cell[18595, 436, 308, 6, 28, "Input",ExpressionUUID->"b49c78bf-a5b2-4d1a-93cf-abea53deacb7"],
Cell[18906, 444, 982, 16, 28, "Input",ExpressionUUID->"9a53b5c3-3713-4cc3-b7b2-d51aefde4cae"]
}, Open  ]],
Cell[CellGroupData[{
Cell[19925, 465, 430, 6, 53, "Subsection",ExpressionUUID->"5570249b-c4a1-496b-a9f0-f70fd1f3d08e"],
Cell[20358, 473, 519, 10, 34, "Text",ExpressionUUID->"94796fc5-7ef6-4608-ab1a-fd52dcabf67c"],
Cell[20880, 485, 3101, 73, 67, "Input",ExpressionUUID->"09d73d03-3e58-4474-93f6-76001c0482b7"]
}, Open  ]],
Cell[CellGroupData[{
Cell[24018, 563, 438, 7, 53, "Subsection",ExpressionUUID->"92d3832b-0022-4489-95e4-a8920b19e807"],
Cell[24459, 572, 1081, 17, 56, "Text",ExpressionUUID->"5673b6f6-41c3-4033-b97c-5341dde8995c"],
Cell[25543, 591, 5237, 126, 124, "Input",ExpressionUUID->"e78b6abd-35fe-4c03-a1be-22c113530382"],
Cell[30783, 719, 7595, 175, 124, "Input",ExpressionUUID->"e1a573d7-6a95-4653-9b36-27dce1c3e278"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[38427, 900, 341, 5, 67, "Section",ExpressionUUID->"6cd23836-a73b-43c9-a898-c6a08e71a94e"],
Cell[38771, 907, 948, 23, 34, "Text",ExpressionUUID->"884dd5a8-24d3-40ac-b1c5-0e5572cd9d47"],
Cell[CellGroupData[{
Cell[39744, 934, 416, 6, 53, "Subsection",ExpressionUUID->"b5c13e16-0a7a-42da-8baa-69da5f8687b9"],
Cell[40163, 942, 643, 10, 34, "Text",ExpressionUUID->"122f3819-2446-41c5-8e9a-5230bc27eab5"],
Cell[40809, 954, 413, 8, 28, "Input",ExpressionUUID->"6eeed15d-e16a-4848-a2cb-6e06a1616b73"]
}, Open  ]],
Cell[CellGroupData[{
Cell[41259, 967, 366, 6, 53, "Subsection",ExpressionUUID->"49fcf1df-dc64-433c-b0ee-db1b21e6f374"],
Cell[41628, 975, 888, 14, 56, "Text",ExpressionUUID->"61804c84-3534-419d-bd68-1b6bffdddf92"],
Cell[42519, 991, 1230, 29, 28, "Input",ExpressionUUID->"19fd3c61-91c4-488c-9b0e-5807014e7e26"],
Cell[43752, 1022, 418, 8, 28, "Input",ExpressionUUID->"0cf839c0-e1d1-45b7-9a50-d360ff8dc928"],
Cell[44173, 1032, 767, 14, 28, "Input",ExpressionUUID->"ee221449-759a-4a8c-969d-c4dc9013f75a"],
Cell[44943, 1048, 667, 15, 28, "Input",ExpressionUUID->"bf93e6cf-73d4-4aea-933d-fcaa9367e6d5"],
Cell[45613, 1065, 5446, 118, 124, "Input",ExpressionUUID->"01f25ab2-cf78-400f-aefe-3bf47aac9f64"]
}, Open  ]],
Cell[CellGroupData[{
Cell[51096, 1188, 476, 7, 53, "Subsection",ExpressionUUID->"5e1e88dc-b8aa-4255-8f78-beda3b1ebdd9"],
Cell[51575, 1197, 361, 6, 34, "Text",ExpressionUUID->"77a31e39-a4d9-458b-ac89-b3e134b00645"],
Cell[51939, 1205, 575, 12, 28, "Input",ExpressionUUID->"a4ef233b-722c-45c8-94c1-68f08b690569"]
}, Open  ]],
Cell[CellGroupData[{
Cell[52551, 1222, 439, 7, 53, "Subsection",ExpressionUUID->"bc01f1c9-54e1-46fd-b30f-c8500beaf26c"],
Cell[52993, 1231, 271, 6, 34, "Text",ExpressionUUID->"30598fb6-1fc7-4583-b5d9-e224ab231c1b"],
Cell[53267, 1239, 5106, 107, 124, "Input",ExpressionUUID->"caaf14cd-fc0c-48cf-b2e5-18646fd8c426"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[58422, 1352, 323, 5, 67, "Section",ExpressionUUID->"6b64f766-2d6f-4b53-b40b-fa2c6dfc2ff6"],
Cell[58748, 1359, 636, 11, 34, "Text",ExpressionUUID->"eb9a74f9-b6ef-429d-ae83-92fb89967539"],
Cell[CellGroupData[{
Cell[59409, 1374, 442, 7, 53, "Subsection",ExpressionUUID->"6fa987bc-30f7-47da-9025-5c67c6e34962"],
Cell[59854, 1383, 586, 10, 56, "Text",ExpressionUUID->"1572f5a2-6dc0-4d52-a2b8-6c3ac30dff2a"],
Cell[60443, 1395, 1809, 44, 48, "Input",ExpressionUUID->"c4d3a3ce-d908-4d7f-b383-eab392505c7e"]
}, Open  ]],
Cell[CellGroupData[{
Cell[62289, 1444, 373, 6, 53, "Subsection",ExpressionUUID->"d7c43cd8-48d9-4aa2-ba08-eb69222275a4"],
Cell[62665, 1452, 405, 8, 34, "Text",ExpressionUUID->"4b21881d-c88a-44d4-9dec-0a736a481564"],
Cell[63073, 1462, 3859, 93, 86, "Input",ExpressionUUID->"fffb1614-bf7c-4e98-be99-4371790c202e"]
}, Open  ]],
Cell[CellGroupData[{
Cell[66969, 1560, 365, 6, 53, "Subsection",ExpressionUUID->"0adcd58b-aab2-490a-a6ac-6cb68724e650"],
Cell[67337, 1568, 415, 8, 34, "Text",ExpressionUUID->"473a5bee-2143-4645-9e02-8d00131556fa"],
Cell[67755, 1578, 3145, 74, 86, "Input",ExpressionUUID->"ef3c24bf-4cad-486c-9b3c-c2892df9ade1"],
Cell[70903, 1654, 4120, 90, 86, "Input",ExpressionUUID->"90865b3e-5949-4057-9f9a-35901ebd95e5"],
Cell[75026, 1746, 2784, 67, 48, "Input",ExpressionUUID->"d6ebdd83-b966-4d44-a03b-58adfbe1bf19"],
Cell[77813, 1815, 3375, 79, 48, "Input",ExpressionUUID->"a990f015-7534-4d07-b31a-df2287d8ccd4"],
Cell[81191, 1896, 3008, 68, 86, "Input",ExpressionUUID->"310d5584-fa8b-480c-ba73-0ab686b1a24b"],
Cell[84202, 1966, 3333, 83, 86, "Input",ExpressionUUID->"a47af384-b280-4cea-bd2d-ddac1f4051ed"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[87584, 2055, 321, 5, 67, "Section",ExpressionUUID->"a67244df-8005-4608-a14c-56ecb05cccd7"],
Cell[87908, 2062, 846, 14, 34, "Text",ExpressionUUID->"386481d8-6253-42aa-ac36-1781ccafba7b"],
Cell[CellGroupData[{
Cell[88779, 2080, 336, 5, 53, "Subsection",ExpressionUUID->"a0a1012f-96e9-417d-878e-a6ade2b6d680"],
Cell[89118, 2087, 3024, 58, 191, "Text",ExpressionUUID->"2cf3dd60-df5e-4e4a-a1cd-e27f4562c9a8"],
Cell[92145, 2147, 621, 12, 28, "Input",ExpressionUUID->"235a3e05-2de2-450b-9104-2eda287cb919"],
Cell[92769, 2161, 1088, 23, 28, "Input",ExpressionUUID->"d2dc7c5a-be7d-42aa-8630-d3df0ae96e4d"],
Cell[93860, 2186, 783, 19, 28, "Input",ExpressionUUID->"397ff26a-d79a-4c5e-bdea-dccccf902a13"],
Cell[94646, 2207, 427, 10, 28, "Input",ExpressionUUID->"8402f768-6c83-4662-a913-6f3deefce798"],
Cell[95076, 2219, 6988, 127, 105, "Input",ExpressionUUID->"70762168-279d-43f3-9bef-366febfa375b"],
Cell[102067, 2348, 4262, 84, 67, "Input",ExpressionUUID->"9e92cbfb-6111-42aa-ad9a-7817d3e05b62"],
Cell[106332, 2434, 2405, 48, 67, "Input",ExpressionUUID->"d1af2056-6cbd-4eb7-b490-f1c1cd06a6ae"],
Cell[108740, 2484, 2249, 53, 48, "Input",ExpressionUUID->"de64e8b6-2f5f-45da-83bf-1e05602777a7"],
Cell[110992, 2539, 8396, 164, 143, "Input",ExpressionUUID->"1c9eadcc-efe2-4752-8bb8-6265a2725a2b"],
Cell[119391, 2705, 716, 18, 28, "Input",ExpressionUUID->"1e61f050-4ff7-4775-9a92-f4c97c814bfc"],
Cell[120110, 2725, 4610, 102, 86, "Input",ExpressionUUID->"4aeb1401-5e32-48c7-bacb-45d2ec78dbb8"],
Cell[124723, 2829, 1572, 35, 28, "Input",ExpressionUUID->"d32e9cd1-d009-44bd-a964-f046c4a20a63"],
Cell[126298, 2866, 3575, 71, 124, "Input",ExpressionUUID->"f58c7147-c401-4f20-9710-c90eef4a5973"],
Cell[129876, 2939, 926, 20, 28, "Input",ExpressionUUID->"b814b62f-7a71-4c38-a8f3-2fe3261e17fb"],
Cell[130805, 2961, 6133, 113, 86, "Input",ExpressionUUID->"95565ad1-9ffa-4fb7-8714-63a9f427d30a"],
Cell[136941, 3076, 981, 22, 28, "Input",ExpressionUUID->"f76cc1e2-71eb-420a-8139-f32f2e1842ea"],
Cell[137925, 3100, 2650, 48, 67, "Input",ExpressionUUID->"328ae089-5efe-4169-8d76-6f80a94d9666"]
}, Open  ]],
Cell[CellGroupData[{
Cell[140612, 3153, 416, 6, 53, "Subsection",ExpressionUUID->"0c294d4a-3dd4-489c-a6a5-29f3f0f6efe3"],
Cell[141031, 3161, 510, 9, 34, "Text",ExpressionUUID->"9ba1deda-dbc7-4600-8f72-c0576d48cd4e"],
Cell[141544, 3172, 355, 9, 28, "Input",ExpressionUUID->"0b72d5cf-67ba-4509-8bf6-737b485ffa73"],
Cell[141902, 3183, 1137, 20, 28, "Input",ExpressionUUID->"a4375eef-890f-495c-84aa-b1dc3584cbd7"],
Cell[143042, 3205, 1233, 19, 28, "Input",ExpressionUUID->"1e2e3fc2-7a60-4164-8224-04b17740da46"],
Cell[144278, 3226, 2010, 32, 28, "Input",ExpressionUUID->"0a7d89ec-f1df-432f-97a2-8575ef91e55a"],
Cell[146291, 3260, 649, 12, 28, "Input",ExpressionUUID->"3b6bbdbe-5fae-4734-93cd-60d1191d0637"],
Cell[146943, 3274, 1080, 17, 28, "Input",ExpressionUUID->"84b8c709-f3bb-4db4-ae91-4a77e64d1f07"]
}, Open  ]],
Cell[CellGroupData[{
Cell[148060, 3296, 378, 6, 53, "Subsection",ExpressionUUID->"35fa132a-9aa0-48b3-a246-6544b82ffe0c"],
Cell[148441, 3304, 371, 8, 34, "Text",ExpressionUUID->"a518538a-d923-48e3-bbb8-db6bad88fbfc"],
Cell[148815, 3314, 885, 23, 28, "Input",ExpressionUUID->"5c7531cb-7d0a-4d52-9639-738b8e5811b4"],
Cell[149703, 3339, 7653, 148, 86, "Input",ExpressionUUID->"021b107b-e74e-4038-b1b5-c07bd4b4dfd7"],
Cell[157359, 3489, 4195, 82, 48, "Input",ExpressionUUID->"adeca30f-f28f-40de-85fe-2fbb1901961f"],
Cell[161557, 3573, 1521, 37, 28, "Input",ExpressionUUID->"d43c99d6-185d-4365-abb2-b50f16c5caed"],
Cell[163081, 3612, 8179, 183, 200, "Input",ExpressionUUID->"e1eec1d9-bc3b-4f5d-87d4-a54710ece320"],
Cell[171263, 3797, 8954, 182, 143, "Input",ExpressionUUID->"63bda061-98dd-4da4-9aa7-38125db5b51e"]
}, Open  ]],
Cell[CellGroupData[{
Cell[180254, 3984, 384, 6, 53, "Subsection",ExpressionUUID->"4325f48d-1a27-42d4-82db-e09bb7008434"],
Cell[180641, 3992, 997, 16, 56, "Text",ExpressionUUID->"75d9e694-79d0-4d87-90ed-4bdd80a32aa2"],
Cell[181641, 4010, 13386, 264, 295, "Input",ExpressionUUID->"e99d5a38-4268-4fca-a66c-ab47136c9287"],
Cell[195030, 4276, 447, 10, 34, "Text",ExpressionUUID->"be4af1aa-7901-4ff7-9e99-a1adbc9da5b7"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[195526, 4292, 159, 3, 67, "Section",ExpressionUUID->"1dd09355-1f20-4db3-a5df-dbc825bdc30d"],
Cell[195688, 4297, 2696, 45, 298, "Text",ExpressionUUID->"8c9ba590-619d-49cd-a50d-978878485bfa"]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature fxpLd0tcfT@RXDw90RK3GLF5 *)
