Page 51349 "HR Medical Schemes List"
{
    CardPageID = "HR Medical Schemes Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "HR Medical Schemes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SchemeNo; Rec."Scheme No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheme No field.';
                }
                field(MedicalInsurer; Rec."Medical Insurer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Insurer field.';
                }
                field(SchemeName; Rec."Scheme Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheme Name field.';
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
                field(DependantsIncluded; Rec."Dependants Included")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dependants Included field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
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

