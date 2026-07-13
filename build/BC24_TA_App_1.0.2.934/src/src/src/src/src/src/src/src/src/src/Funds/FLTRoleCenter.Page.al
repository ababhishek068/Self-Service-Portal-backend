Page 50643 "FLT Role Center"
{

    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Reports)
            {
                Caption = 'FLT Reports';
                Image = SNInfo;
                action(Vehicles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Vehicle List";
                    ToolTip = 'Executes the Vehicle List action.';
                }
                action(Drivers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Driver List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "FLT Driver List";
                    ToolTip = 'Executes the Driver List action.';
                }
               
                action(WT)
                {
                    ApplicationArea = Basic;
                    Caption = 'Work Ticket';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "FLT Daily Work Ticket";
                    ToolTip = 'Executes the Work Ticket action.';
                }
                action("Transport Requisitions")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Transport Requisition Report";
                    ToolTip = 'Executes the Transport Requisitions action.';
                }
                action("Vehicle Movement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Vehicle Movement Report";
                    ToolTip = 'Executes the Vehicle Movement action.';
                }

                action("Fleet Maintenance")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    RunObject = Report "Maintenance Report";
                    ToolTip = 'Executes the Fleet Maintenance action.';
                }
            }
        }
        area(sections)
        {
            group(Vehicle_Man)
            {
                Caption = 'Vehicle Management';
                Image = AnalysisView;
                action(VehicleCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Card';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "Flt Vehicle Card List";
                    ToolTip = 'Executes the Vehicle Card action.';
                }
                action(DriverCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Driver Card';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "Flt Driver List";
                    ToolTip = 'Executes the Driver Card action.';
                }
                 action(inventorytools)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Tools and Spares Handover';
                    Image = "Report";
                    Promoted = true;
                    RunObject = page "Inventory Tools and spares";
                    ToolTip = 'Executes the Inventory Tools and Spares Handover List action.';
                }
                action(sparereturns)
                {
                    ApplicationArea=basic;
                    Caption='Spares Returns';
                    Image=Payables;
                    Promoted=true;
                    RunObject=page "Spares Return No";

                }
                 action(vehicletransfer)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle transfer';
                    Image = "Report";
                    Promoted = true;
                    RunObject = page "vehicle transfer List";
                    ToolTip = 'Executes the Inventory Tools and Spares Handover List action.';
                }
                action(Fuel)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fuel Card';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "Fuel Card Setup";
                    ToolTip = 'Executes the Fuel Card action.';
                }
            }
            group(Transport_re)
            {
                Caption = 'Transport Requisitions';
                Image = Travel;
                action(TransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Requisition';
                    RunObject = Page "FLT Transport Requisition List";
                    ToolTip = 'Executes the Transport Requisition action.';
                }
                action(SubmittedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Transport Requisition';
                    RunObject = Page "FLT Submitted Transport List";
                    ToolTip = 'Executes the Submitted Transport Requisition action.';
                }
                action(ApprovedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Transport Requisition';
                    RunObject = Page "FLT Approved transport Req";
                    ToolTip = 'Executes the Approved Transport Requisition action.';
                }
                action(ClosedTransportRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Transport Requisition';
                    RunObject = Page "FLT Transport - Closed List";
                    ToolTip = 'Executes the Closed Transport Requisition action.';
                }
            }
            group(Safari_Notices)
            {
                Caption = 'Travel Notices';
                Image = ResourcePlanning;
                action(Travel_Notices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Notice';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT Safari Notices List";
                    ToolTip = 'Executes the Travel Notice action.';
                }
                action(ApprovedTravelNotices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Travel Notices';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Posted Safari Notices List";
                    ToolTip = 'Executes the Approved Travel Notices action.';
                }
            }
            group(Fuel_req1)
            {
                Caption = 'Fuel Requisitions';
                Image = Intrastat;
                action(CardFuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fuel Recharge Card Request';
                    Image = Payables;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Fuel Recharge Card list";
                    ToolTip = 'Executes the Fuel Recharge Card Request action.';
                }
                action(Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fuel Requisitions';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "FLT Fuel Requestion List";
                    ToolTip = 'Executes the Fuel Requisitions action.';
                }
                action(sub_Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Fuel Requisitions';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Fuel Req Submitted List";
                    ToolTip = 'Executes the Submitted Fuel Requisitions action.';
                }
                action(Unpaid_Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unpaid Fuel Requisitions';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Fuel Req Unpaid";
                    ToolTip = 'Executes the Unpaid Fuel Requisitions action.';
                }
                action(Closed_Fuel_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed/Paid Fuel Requisitions';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Fuel Req Closed List";
                    ToolTip = 'Executes the Closed/Paid Fuel Requisitions action.';
                }
                action(Batch_fuel_Pay)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batch Fuel Payments';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Fule Payment Batch List";
                    ToolTip = 'Executes the Batch Fuel Payments action.';
                }
            }
            group("Work Tickets")
            {
                Caption = 'Work Tickets';
                Image = Marketing;
                action(workTick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Daily Work Tickets';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT Daily Work Ticket List";
                    ToolTip = 'Executes the Daily Work Tickets action.';
                }
                action(Closed_Work_Tick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Daily Work Tickets';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Closed Work Ticket List";
                    ToolTip = 'Executes the Closed Daily Work Tickets action.';
                }
            }
            group(Maint_Req)
            {
                Caption = 'Maintenance Request';
                Image = Receivables;
                action(main_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Maintenance Request';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT Maintenance Request List";
                    ToolTip = 'Executes the Maintenance Request action.';
                }
                action(subMmain_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submitted Maintenance Request';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Maintenance Req Sub. List";
                    ToolTip = 'Executes the Submitted Maintenance Request action.';
                }
                action(Appr_main_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Maintenance Request';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT Approved  Maintenance Req";
                    ToolTip = 'Executes the Approved Maintenance Request action.';
                }
                action(Closed_main_Req)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Maintenance Request';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT ClosedMaintenance Req List";
                    ToolTip = 'Executes the Closed Maintenance Request action.';
                }
            }
            group(Setup)
            {
                Caption = 'Setups';
                Image = Setup;
                action(FleetMan_setup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fleet Mgt Setup';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT Fleet Mgt Setup";
                    ToolTip = 'Executes the Fleet Mgt Setup action.';
                }
                action(flet_man_app_setup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fleet Mgt Approval Setup';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "FLT Mgt Approval Setup";
                    ToolTip = 'Executes the Fleet Mgt Approval Setup action.';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Alerts;
                action(PendingMyApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Approval Entries";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action(MyApprovalrequests)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action(StoresRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action("Purchase Requisition")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action(ImprestRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action(LeaveApplications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action(MyApprovedLeaves)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
                action("Page FLT Transport Requisition2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transport Requisition';
                    RunObject = Page "FLT Transport Requisition List";
                    ToolTip = 'Executes the Transport Requisition action.';
                }
                action(Travel_Notices2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Notice';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "FLT Safari Notices List";
                    ToolTip = 'Executes the Travel Notice action.';
                }
                action(MyAudits)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Audits';
                    RunObject = Page "Int. Audit Auditee Response";
                    ToolTip = 'Executes the My Audits action.';
                }
            }
        }
    }

}

