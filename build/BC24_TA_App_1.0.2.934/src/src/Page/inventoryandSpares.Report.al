namespace ABH_UAT.ABH_UAT;

report 50372 "inventory and Spares"
{
    ApplicationArea = All;
    Caption = 'inventory and Spares';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/blacklist.rdl';
    dataset
    {
        dataitem(SParesandtools; "SPares and tools")
        {
            column(Spare_Code;"Spare Code"){}
            column(Spare_description;"Spare description"){}
            column(Chassis_No;"Chassis No"){}
            column(Plate_No;"Plate No"){}
            column(Condition;Condition){}
            trigger OnAfterGetRecord()
            begin
                spareshead.Reset();
                spareshead.SetRange(spareshead."Chassis No",SParesandtools."Chassis No");
                spareshead.SetRange(spareshead."Issue No",SParesandtools."Issue No");
                spareshead.SetRange(spareshead."Plate No",SParesandtools."Plate No");
                if spareshead.FindFirst() then begin
                    yom:=spareshead."Year of Manufacture";
                    model:=spareshead.Model;
                    color:=spareshead.Colour;
                    loadcap:=spareshead."Loading Capacity ";
                    fuel:=spareshead."Type of fuel";
                    engineno:=spareshead."Engine No";
                    noofcylinder:=spareshead."Numbers of Cylinders ";
                end;
            end;
            
        }
        
    }
    
    
    var
    spareshead: Record "Inventory Spares Handover";
    issuedto: Text[50];
    issuedBy: text[50];
    noofcylinder:Integer;
    model: Code[50];
    yom: Integer;
    fuel: Option;
    color: text[20];
    loadcap: Decimal;
    engineno:code[50];
}
