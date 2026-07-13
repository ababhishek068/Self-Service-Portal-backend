Page 50097 "Prog. Capacity Declaratio List"
{
    PageType = ListPart;
    SourceTable = "Programmes Capacity Declaratio";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ProgrammeCode; Rec."Programme Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(SchoolCode; Rec."School Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the School Code field.';
                }
                field(KUCCPSCapacity; Rec."KUCCPS Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the KUCCPS Capacity field.';
                }
                field(SSPCapacity; Rec."SSP Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SSP Capacity field.';
                }
                field(DeclaredCapacity; Rec."Declared Capacity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Declared Capacity field.';
                }
            }
        }
    }

    actions { }
}

