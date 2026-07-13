page 50237 "Contract Card1"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Contract;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Contract Reference No"; Rec."Contract Reference No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract Reference No field.';

                }
                field("File Number"; Rec."File Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Number field.';
                }

                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract No. field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Contarctor No."; Rec."Contractor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contractor No. field.';
                }
                field("Contrator Name"; Rec."Contractor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contractor Name field.';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Effective Date field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field("Contract Value"; Rec."Contract Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Value field.';
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    trigger OnValidate()
                    begin
                        Dim1 := '';
                        DimRec.reset;
                        dimrec.setrange(Code, Rec."Global Dimension 1 Code");
                        if dimrec.find('-') then begin
                            Dim1 := DimRec.Name;
                            DimLabel1 := DimRec."Dimension Code";
                        end
                    end;
                }
                field("."; Dim1)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim1 field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    trigger OnValidate()
                    begin
                        Dim2 := '';
                        DimRec.reset;
                        dimrec.setrange(Code, Rec."Shortcut Dimension 2 Code");
                        if dimrec.find('-') then begin
                            Dim2 := DimRec.Name;
                            DimLabel2 := DimRec."Dimension Code";
                        end
                    end;
                }
                field(".."; Dim2)
                {
                    ApplicationArea = all;
                    editable = false;
                    ToolTip = 'Specifies the value of the Dim2 field.';
                }

                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    trigger OnValidate()
                    begin
                        Rec.Dim3 := '';
                        DimRec.reset;
                        dimrec.setrange(Code, Rec."Shortcut Dimension 3 Code");
                        if dimrec.find('-') then begin
                            Rec.Dim3 := DimRec.Name;
                            DimLabel3 := DimRec."Dimension Code";
                        end
                    end;
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Subject Matter"; Rec."Subject Matter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Subject Matter field.';
                }
                field("Remarks Section"; Rec."Remarks Section")
                {
                    ApplicationArea = Basic;
                    Caption = 'Remarks';
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Status field.';
                }
                field(Status; Rec.Status)
                {
                    caption = 'Approval Status';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepared By';
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Milestone)
            {
                Caption = 'Contract Milestones';
                ApplicationArea = All;
                RunObject = page "Contract Milestones";
                RunPageLink = "Contract No" = field("Contract Reference No");
                ToolTip = 'Executes the Contract Milestones action.';
            }
        }
    }

    var
        DimRec: Record "Dimension Value";
        Dim1: Text[200];
        DimLabel1: Text[200];
        DimLabel2: Text[200];
        DimLabel3: Text[200];
        Dim2: Text[200];
}