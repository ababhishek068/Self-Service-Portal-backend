Report 50275 "Programmes Capacity Declaratio"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    // RDLCLayout = './Layouts/ProgrammesCapacityDeclaratio.rdlc';

    dataset
    {
        dataitem("Programmes Capacity Declaratio"; "Programmes Capacity Declaratio")
        {
            RequestFilterFields = "School Code", "Programme Code";
            column(ReportForNavId_1; 1) { }
            column(ProgrammeCode_ProgrammesCapacityDeclaratio; "Programmes Capacity Declaratio"."Programme Code") { }
            column(AcademicYear_ProgrammesCapacityDeclaratio; "Programmes Capacity Declaratio"."Academic Year") { }
            column(DeclaredCapacity_ProgrammesCapacityDeclaratio; "Programmes Capacity Declaratio"."Declared Capacity") { }
            column(Approved_ProgrammesCapacityDeclaratio; "Programmes Capacity Declaratio".Approved) { }
            column(Code_ProgrammesCapacityDeclaratio; "Programmes Capacity Declaratio".Code) { }
            column(Description_ProgrammesCapacityDeclaratio; "Programmes Capacity Declaratio".Description) { }
            column(SchoolCode_ProgrammesCapacityDeclaratio; 'SCHOOL OF ' + DimRec.Name) { }

            trigger OnAfterGetRecord()
            begin
                "Programmes Capacity Declaratio".CalcFields("School Code");
                DimRec.Reset;
                DimRec.SetRange(DimRec."Global Dimension No.", 3);
                DimRec.SetRange(DimRec.Code, "School Code");
                if DimRec.Find('-') then;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        DimRec: Record "Dimension Value";
}

