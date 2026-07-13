Page 51372 "HMS Radiology View Test Line"
{
    Editable = false;
    PageType = Document;
    SourceTable = "HMS Radiology Form Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(RadiologyTypeCode; Rec."Radiology Type Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Radiology Type Code field.';
                }
                field(RadiologyTypeName; Rec."Radiology Type Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Radiology Type Name field.';
                }
                field(AssignedUserID; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                }
                field(PerformedDate; Rec."Performed Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performed Date field.';
                }
                field(PerformedTime; Rec."Performed Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performed Time field.';
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Completed field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RadiologyImages)
            {
                ApplicationArea = Basic;
                Caption = 'Radiology Image(s)';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Radiology Image(s) action.';

                trigger OnAction()
                begin
                    RadiologyLine.Reset;
                    RadiologyLine.SetRange(RadiologyLine."Radiology no.", Rec."Radiology no.");
                    RadiologyLine.SetRange(RadiologyLine."Radiology Type Code", Rec."Radiology Type Code");
                    Page.Run(52573, RadiologyLine);
                end;
            }
        }
    }

    var
        RadiologyLine: Record "HMS Radiology Form Line";
}

