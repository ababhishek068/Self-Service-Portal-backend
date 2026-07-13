Page 50537 "Posted Store Requisitions"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    CardPageId = "Store Req Header Posted";
    SourceTable = "Store Requistion Header";
    SourceTableView = where(Status = filter(Posted));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(RequisitionType; Rec."Requisition Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
                }
                field(Requestdate; Rec."Request date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request date field.';
                }
                field(RequiredDate; Rec."Required Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(FunctionName; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(BudgetCenterName; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field(RequestDescription; Rec."Request Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Description field.';
                }
                field(IssuingStore; Rec."Issuing Store")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issuing Store field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(IssueDate; Rec."Issue Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issue Date field.';
                }
                field(SRNNo; Rec."SRN.No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SRN.No field.';
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Committed field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = PreviewChecks;
                    Promoted = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Print/Preview action.';

                    trigger OnAction()
                    var
                        SRN: report "Store Requisition";
                        SRNRec: Record "Store Requistion Header";
                    begin
                        SRNRec.Reset;
                        SRNRec.SetFilter(SRNRec."No.", Rec."No.");
                        if SRNRec.Find('-') then begin
                            SRN.SetTableView(SRNRec);
                            SRN.run();
                        end;
                        // REPORT.Run(70135450, true, true, SRNRec);
                    end;
                }
            }
        }
    }



    procedure UpdateControls()
    begin

        /* IF Status<>Status::Released THEN BEGIN
         CurrForm."Issue Date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
         CurrForm."Issue Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END;
            IF Status=Status::Open THEN BEGIN
         CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
         CurrForm."Request date" .EDITABLE:=TRUE;
         CurrForm."Responsibility Center" .EDITABLE:=TRUE;
         CurrForm."Issuing Store" .EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
         CurrForm."Request Description".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
         CurrForm."Required Date".EDITABLE:=TRUE;
         CurrForm.UPDATECONTROLS();
         END ELSE BEGIN
         CurrForm."Responsibility Center".EDITABLE:=FALSE;
         CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
         CurrForm."Request Description".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
         CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
         CurrForm."Required Date".EDITABLE:=FALSE;
          CurrForm."Request date".EDITABLE:=FALSE;
         CurrForm.UPDATECONTROLS();
         END
         */

    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}

