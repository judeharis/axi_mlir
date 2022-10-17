import dataflow as df
import itertools
import utils as u

class dfLeafBlock:
    counter = 0

    def __init__(self, nodes, depth):
        self.id = dfLeafBlock.counter
        self.nodes = nodes
        self.depth = depth
        self.variations = []
        dfLeafBlock.counter += 1

    # def __str__(self):
    #     s = " {L" + str(self.id) + " D" + str(self.depth)+ ": ("
    #     for n in self.nodes:
    #         s += str(n)
    #     s += ")} "
    #     return s

    def __str__(self):
        s = " {L" + str(self.id) + " D" + str(self.depth) + "} "
        return s

    def __repr__(self):
        return str(self)

    def genVariations(self, ilist):
        cmdlist = []
        for n in self.nodes:
            cmdlist.append(n.cmd)
        ovs = df.createOrderVariations(cmdlist)
        for i in ovs:
            # print("ovs:" + str(i))
            ov = [i] if not isinstance(i, list) else i
            ovopcodes = df.getCMDList(ov, ilist)
            # print("ilist:" + str(ovopcodes))
            if not df.checkForNone(ovopcodes):
                self.variations.append(ovopcodes)


class dfNode:
    counter = 0

    def __init__(self, isTree: bool, depth, cmd=None):
        self.isTree = isTree
        self.id = dfNode.counter
        self.nodes = []
        self.cnodes = []
        dfNode.counter += 1
        self.cmd = cmd
        self.depth = depth

    def __str__(self):
        s = " [" + str(self.id)
        s += " : "
        if len(self.cnodes) > 0:
            for n in self.cnodes:
                s += str(n)
        else:
            s += str(self.cmd)
        s += "] "
        return s

    def __repr__(self):
        return str(self)

    def addNode(self, node):
        self.nodes.append(node)

    def findLeafBlocks(self):
        cur_lb = []
        for node in self.nodes:
            if node.isTree:
                if len(cur_lb) != 0:
                    self.cnodes.append(dfLeafBlock(cur_lb, node.depth))
                self.cnodes.append(node)
                cur_lb = []
            else:
                cur_lb.append(node)
        if len(cur_lb) != 0:
            self.cnodes.append(dfLeafBlock(cur_lb, node.depth))

    # def traverseCNodes(self):
    #     curres= []
    #     for cnode in self.cnodes:
    #         if isinstance(cnode,dfLeafBlock):
    #             curres.append(cnode)
    #         else:
    #             curres.append(cnode.traverseCNodes())
    #     return curres

    def traverseCNodes(self):
        curres = []
        for cnode in self.cnodes:
            if isinstance(cnode, dfLeafBlock):
                curres.append(cnode)
            else:
                curres += cnode.traverseCNodes()
        return curres

    def traverseAndCompress(self):
        self.findLeafBlocks()
        for node in self.nodes:
            node.traverseAndCompress()

    def generateVarlistForTree(self, ilist):
        if self.isTree:
            for node in self.cnodes:
                if isinstance(node, dfLeafBlock):
                    node.genVariations(ilist)
                else:
                    node.generateVarlistForTree(ilist)


def bracketedDFtoTreeDF(dflist, tree, depth):
    for i in dflist:
        if isinstance(i, list):
            sTree = dfNode(True, depth + 1)
            bracketedDFtoTreeDF(i, sTree, depth + 1)
            tree.addNode(sTree)
        else:
            tree.addNode(dfNode(False, depth + 1, i))


def bracketedToCleanVariations(df,ilist):
    # Creates a DFTree from bracketed DF format
    osdt = dfNode(True, 0)
    bracketedDFtoTreeDF(df, osdt, 0)

    # Generates leafBlocks within tree --- any leaf nodes (commands like SEND(0) is a leaf node)
    #  which are consectutive are grouped into a leafBlocks
    osdt.traverseAndCompress()

    # For each leafBlocks genereate all potential opcode variations to
    # achieve the correponding commands within the leafBlocks
    osdt.generateVarlistForTree(ilist)

    # Create a list of leafBlocks from the tree
    leafBlocks = osdt.traverseCNodes()



    # function to save all the opcode variations per leafBlock
    # def x(j):
    #     return [i.variations if isinstance(i, dfLeafBlock) else x(i) for i in j]
    def x(j,lis):
        for i in j:
            lis.append(i.variations) if isinstance(i, dfLeafBlock) else lis.append(x(i,lis))
        return lis
        

    # function to create/remove brackets depending on LeafBlock depth
    def y(j, d):
        return (
            (j[0] if d < 0 and isinstance(j, list) and not len(j)>1 else j) if d <= 0 else [y(j, d - 1)]
        )

    # save all the opcode variations per leafBlock
    leafBlocks_varlist = x(leafBlocks,[])



    allOpcodeVariations = []
    # Create Cartesian product of all possible opcode variations for a given dataflow
    if(len(leafBlocks_varlist) <2):
        for i in leafBlocks_varlist[0]:
            allOpcodeVariations.append(tuple([i]))

    else:
        for element in itertools.product(*leafBlocks_varlist):
            allOpcodeVariations.append(element)

    # print("leafBlocks[0]", leafBlocks[0].variations)
    # print("leafBlocks_varlist",leafBlocks_varlist)
    # print("allOpcodeVariations",allOpcodeVariations)

    # Adjust creates All Opcode Variation with corrent list bracketing
    clean_allOpcodeVariations = []
    lpervar = len(leafBlocks)
    for i in allOpcodeVariations:
        # print("i",i)
        flow = []
        for j in range(lpervar):
            cur = u.flatten(i[j], [])
            # print("cur",cur)
            # print("i[j]",i[j])
            addtoflow = y(cur, leafBlocks[j].depth - 2)
            # print("addtoflow", addtoflow,"leafBlocks[j].depth", leafBlocks[j].depth-2)
            if(lpervar==1 and  isinstance(addtoflow, list)):
                flow= addtoflow
            else:
                flow.append(y(cur, leafBlocks[j].depth - 2))
        # print("flow:",flow)
        clean_allOpcodeVariations.append(flow)
    # print(clean_allOpcodeVariations)
    return clean_allOpcodeVariations
