Page 51339 "HR Medical Schemes Card"
{
    PageType = Card;
    PromotedActionCategories = 'Manage,Process,Report,Members';
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
                field(MedicalInsurer; Rec."Medical Insurer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Insurer field.';
                }
                field(InsurerName; Rec."Insurer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Insurer Name field.';
                }
                field("Broker No"; Rec."Broker No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Broker No field.';
                }
                field("Broker Name"; Rec."Broker Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Broker Name field.';
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

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(MedicalSchemeMembers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Medical Scheme Members';
                    Image = PersonInCharge;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Medical Scheme Members List";
                    RunPageLink = "Scheme No" = field("Scheme No");
                    ToolTip = 'Executes the Medical Scheme Members action.';
                }
                action("Cover Type")
                {
                    ApplicationArea = Basic;
                    Image = Check;
                    Promoted = true;
                    RunObject = Page "Scheme schedule";
                    RunPageLink = "Scheme No" = field("Scheme No");
                    ToolTip = 'Executes the Cover Type action.';

                    trigger OnAction()
                    begin
                        //hhh
                    end;
                }
            }
        }
    }
}

