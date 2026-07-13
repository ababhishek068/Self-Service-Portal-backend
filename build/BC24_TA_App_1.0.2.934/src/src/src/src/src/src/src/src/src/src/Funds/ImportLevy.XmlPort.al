xmlport 50008 "Import Levy"
{
    Direction = Import;
    FileName = 'C:\Inbound\Sacco Societies Regulatory Authority\Supervision - Levies\Levy Computation and Cappe Template.csv';
    schema
    {

        textelement(NodeName1)
        {
            tableelement(Levy; "Temp Levy Computations")
            {
                fieldattribute(NodeName3; Levy."Line No.") { }
                fieldattribute(NodeName4; Levy."CS. NO") { }
                fieldattribute(NodeName5; Levy."TOTAL DEPOSITS") { }
                fieldattribute(NodeName6; Levy."LEVY COMPUTATION") { }
                fieldattribute(NodeName7; Levy."LEVY CAPPED") { }
                fieldattribute(NodeName8; Levy.POSTED) { }
            }
        }
    }






}