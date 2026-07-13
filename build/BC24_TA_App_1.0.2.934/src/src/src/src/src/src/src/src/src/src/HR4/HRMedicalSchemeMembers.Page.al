Page 51350 "HR Medical Scheme Members"
{
    PageType = Card;
    SourceTable = "HR Medical Schemes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SchemeNo; Rec."Scheme No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheme No field.';
                }
                field(SchemeName; Rec."Scheme Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheme Name field.';
                }
                field(MedicalInsurer; Rec."Medical Insurer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Insurer field.';
                }
                field(Inpatientlimit; Rec."In-patient limit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the In-patient limit field.';
                }
                field(Outpatientlimit; Rec."Out-patient limit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Out-patient limit field.';
                }
                field(AreaCovered; Rec."Area Covered")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Area Covered field.';
                }
                field(InsurerName; Rec."Insurer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Insurer Name field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(DependantsIncluded; Rec."Dependants Included")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dependants Included field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        if userSetUp.Get(UserId) then begin
            if userSetUp."Medical Team" = false then
                Error('You do not have permission to access this page!!!');
        end;
    end;

    var
        userSetUp: Record "User Setup";
}

