/// <summary>
/// SSP Facility UAT — maintenance actions (R35-R44), work-ticket flight booking
/// (R45-R48) and procurement budget template (R59-R61).
/// PUBLISH AS SOAP WEB SERVICE: object = this codeunit, Service Name = "CuPortalFacility".
/// Parameter names must not be changed — the portal backend calls them by name.
/// </summary>
codeunit 52161 "Portal Facility Mgt."
{
    // ---------------------------------------------------------------------
    // Maintenance (FLT Fuel & Maintenance Req. 50865 companion, table 52163)
    // ---------------------------------------------------------------------

    /// <summary>Stamp a portal-created FLT requisition as a maintenance request and store the SSP template fields.</summary>
    procedure MarkAsMaintenanceRequest(requisitionNo: Code[20]; employeeNo: Code[20]; requestType: Integer; faTagNumber: Code[30]; vehicleNo: Code[30]; item: Text[100]; quantity: Decimal; priority: Text[20]; location: Text[100]; issueDescription: Text[500]; currentOdometer: Decimal; lastServiceOdometer: Decimal): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
    begin
        if requisitionNo = '' then
            exit(false);
        if not Extra.Get(requisitionNo) then begin
            Extra.Init();
            Extra."Requisition No." := requisitionNo;
            Extra.Insert(true);
        end;
        Extra."Employee No." := employeeNo;
        Extra."Request Type" := requestType;
        Extra."FA Tag Number" := faTagNumber;
        Extra."Vehicle No." := vehicleNo;
        Extra.Item := item;
        Extra.Quantity := quantity;
        Extra.Priority := priority;
        Extra.Location := location;
        Extra."Issue Description" := issueDescription;
        if currentOdometer > 0 then begin
            Extra."Current Odometer" := currentOdometer;
            Extra."Next Service KM" := currentOdometer + 5000; // R41: service due every 5,000 km
        end;
        if lastServiceOdometer > 0 then
            Extra."Last Service Odometer" := lastServiceOdometer;
        Extra.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R39: technical manager assigns an internal technician.</summary>
    procedure AssignMaintenanceTechnician(requisitionNo: Code[20]; technicianNo: Code[20]; myUserID: Code[50]): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
    begin
        if (requisitionNo = '') or (technicianNo = '') then
            exit(false);
        EnsureMaintenanceExtra(Extra, requisitionNo);
        Extra."Assigned Technician" := technicianNo;
        Extra."Assigned By" := myUserID;
        Extra."Assigned On" := CurrentDateTime;
        Extra.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R40: requestor confirms receipt of the maintained FA / vehicle.</summary>
    procedure ConfirmMaintenanceReceipt(requisitionNo: Code[20]; remarks: Text[100]; myUserID: Code[50]): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
    begin
        if requisitionNo = '' then
            exit(false);
        EnsureMaintenanceExtra(Extra, requisitionNo);
        Extra."FA Received By" := myUserID;
        Extra."FA Received Date" := Today;
        Extra."Receipt Remarks" := remarks;
        Extra.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R41/R42: save odometer readings; Next Service KM = current + 5,000.</summary>
    procedure SaveMaintenanceOdometer(requisitionNo: Code[20]; currentOdometer: Decimal; lastServiceOdometer: Decimal): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
    begin
        if (requisitionNo = '') or (currentOdometer <= 0) then
            exit(false);
        EnsureMaintenanceExtra(Extra, requisitionNo);
        Extra."Current Odometer" := currentOdometer;
        if lastServiceOdometer > 0 then
            Extra."Last Service Odometer" := lastServiceOdometer;
        Extra."Next Service KM" := currentOdometer + 5000;
        Extra.Modify(true);
        exit(true);
    end;

    local procedure EnsureMaintenanceExtra(var Extra: Record "Portal Fuel Maint. Extra"; requisitionNo: Code[20])
    begin
        if Extra.Get(requisitionNo) then
            exit;
        Extra.Init();
        Extra."Requisition No." := requisitionNo;
        Extra.Insert(true);
    end;

    // ---------------------------------------------------------------------
    // Work ticket flight booking (FLT Work Ticket 50866 companion, table 52162)
    // ---------------------------------------------------------------------

    /// <summary>UAT R45/R46: save the flight-booking fields of a work ticket.</summary>
    procedure SaveWorkTicketFlightDetails(ticketNo: Code[20]; travelerEmployeeNo: Code[20]; flightFrom: Text[100]; flightTo: Text[100]; departureDate: Text; returnDate: Text; ticketClass: Integer; airlinePreference: Text[100]; justification: Text[250]): Boolean
    var
        Flight: Record "Portal Work Ticket Flight";
        Employee: Record Employee;
        ParsedDate: Date;
    begin
        if (ticketNo = '') or (flightFrom = '') or (flightTo = '') then
            exit(false);
        if not ParsePortalDate(departureDate, ParsedDate) then
            exit(false);
        if not Flight.Get(ticketNo) then begin
            Flight.Init();
            Flight."Ticket No." := ticketNo;
            Flight.Insert(true);
        end;
        Flight."Booking Type" := 'Flight';
        Flight."Traveler Employee No." := travelerEmployeeNo;
        if Employee.Get(travelerEmployeeNo) then
            Flight."Traveler Name" := CopyStr(Employee.FullName(), 1, MaxStrLen(Flight."Traveler Name"));
        Flight."Flight From" := flightFrom;
        Flight."Flight To" := flightTo;
        Flight."Departure Date" := ParsedDate;
        if ParsePortalDate(returnDate, ParsedDate) then
            Flight."Return Date" := ParsedDate
        else
            Flight."Return Date" := 0D;
        if ticketClass = 2 then
            Flight."Ticket Class" := 'Business'
        else
            Flight."Ticket Class" := 'Economy';
        Flight."Airline Preference" := airlinePreference;
        Flight."Booking Justification" := justification;
        Flight.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R48: record the booking confirmation receipt.</summary>
    procedure ConfirmWorkTicketBooking(ticketNo: Code[20]; confirmationNo: Code[50]; myUserID: Code[50]): Boolean
    var
        Flight: Record "Portal Work Ticket Flight";
    begin
        if (ticketNo = '') or (confirmationNo = '') then
            exit(false);
        if not Flight.Get(ticketNo) then begin
            Flight.Init();
            Flight."Ticket No." := ticketNo;
            Flight.Insert(true);
        end;
        Flight."Booking Confirmation No." := confirmationNo;
        Flight."Booking Confirmed" := true;
        Flight."Booking Confirmed Date" := Today;
        Flight."Confirmed By" := myUserID;
        Flight.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R47: submit a completed work-ticket / flight booking to the configured manager workflow.</summary>
    procedure RequestWorkTicketApproval(ticketNo: Code[20]): Boolean
    var
        WorkTicket: Record "FLT-Daily Work Ticket Header";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        Variant: Variant;
    begin
        if ticketNo = '' then
            exit(false);
        if not WorkTicket.Get(ticketNo) then
            Error('Work ticket %1 was not found.', ticketNo);
        Variant := WorkTicket;
        if not CustomApprovals.CheckApprovalsWorkflowEnabled(Variant) then
            Error('No approval workflow is enabled for work tickets.');
        CustomApprovals.OnSendDocForApproval(Variant);
        exit(true);
    end;

    /// <summary>Cancel a pending work-ticket approval request before a manager decision.</summary>
    procedure CancelWorkTicketApproval(ticketNo: Code[20]): Boolean
    var
        WorkTicket: Record "FLT-Daily Work Ticket Header";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        Variant: Variant;
    begin
        if ticketNo = '' then
            exit(false);
        if not WorkTicket.Get(ticketNo) then
            Error('Work ticket %1 was not found.', ticketNo);
        Variant := WorkTicket;
        CustomApprovals.OnCancelDocApprovalRequest(Variant);
        exit(true);
    end;

    // ---------------------------------------------------------------------
    // Procurement budget template (tables 52164 / 52165)
    // ---------------------------------------------------------------------

    /// <summary>UAT R59: department or district opens a budget template.</summary>
    procedure SaveProcurementPlanHeader(budgetName: Code[50]; globalDim1: Code[20]; globalDim2: Code[20]; planPeriod: Code[20]): Boolean
    var
        Header: Record "Portal Procurement Plan Hdr.";
    begin
        if (budgetName = '') or (planPeriod = '') then
            exit(false);
        if Header.Get(budgetName, globalDim1, globalDim2, planPeriod) then
            exit(true); // already exists — idempotent
        Header.Init();
        Header."Budget Name" := budgetName;
        Header."Global Dimension 1" := globalDim1;
        Header."Global Dimension 2" := globalDim2;
        Header."Plan Period" := planPeriod;
        Header.Status := 'Open';
        Header."Created By" := CopyStr(UserId(), 1, MaxStrLen(Header."Created By"));
        Header.Insert(true);
        exit(true);
    end;

    /// <summary>UAT R60: itemised procurement budget plan line (upsert).</summary>
    procedure SaveProcurementPlanLine(budgetName: Code[50]; department: Code[20]; lineType: Integer; typeNo: Code[30]; globalDim1: Code[20]; planPeriod: Code[20]; quantity: Decimal; unitCost: Decimal; planDate: Text): Boolean
    var
        Line: Record "Portal Procurement Plan Line";
        ParsedDate: Date;
    begin
        if (budgetName = '') or (typeNo = '') or (planPeriod = '') then
            exit(false);
        if PlanIsSubmitted(budgetName, globalDim1, department, planPeriod) then
            Error('Procurement plan %1 / %2 has already been submitted and can no longer be changed.', budgetName, planPeriod);
        if not Line.Get(budgetName, department, lineType, typeNo, globalDim1, planPeriod) then begin
            Line.Init();
            Line."Budget Name" := budgetName;
            Line.Department := department;
            Line.Type := lineType;
            Line."Type No." := typeNo;
            Line."Global Dimension 1" := globalDim1;
            Line."Plan Period" := planPeriod;
            Line.Insert(true);
        end;
        Line.Description := ResolvePlanLineDescription(lineType, typeNo);
        Line.Quantity := quantity;
        Line."Unit Cost" := unitCost;
        Line.Amount := quantity * unitCost;
        if ParsePortalDate(planDate, ParsedDate) then
            Line."Plan Date" := ParsedDate;
        Line.Modify(true);
        exit(true);
    end;

    /// <summary>Remove one plan line (blocked after submission).</summary>
    procedure DeleteProcurementPlanLine(budgetName: Code[50]; department: Code[20]; lineType: Integer; typeNo: Code[30]; globalDim1: Code[20]; planPeriod: Code[20]): Boolean
    var
        Line: Record "Portal Procurement Plan Line";
    begin
        if PlanIsSubmitted(budgetName, globalDim1, department, planPeriod) then
            Error('Procurement plan %1 / %2 has already been submitted and can no longer be changed.', budgetName, planPeriod);
        if not Line.Get(budgetName, department, lineType, typeNo, globalDim1, planPeriod) then
            exit(false);
        Line.Delete(true);
        exit(true);
    end;

    /// <summary>UAT R61: submit the itemised procurement budget plan.</summary>
    procedure SubmitProcurementPlan(budgetName: Code[50]; globalDim1: Code[20]; globalDim2: Code[20]; planPeriod: Code[20]): Boolean
    var
        Header: Record "Portal Procurement Plan Hdr.";
        Line: Record "Portal Procurement Plan Line";
    begin
        if not Header.Get(budgetName, globalDim1, globalDim2, planPeriod) then
            exit(false);
        Line.SetRange("Budget Name", budgetName);
        Line.SetRange("Plan Period", planPeriod);
        if Line.IsEmpty() then
            Error('Add at least one plan line before submitting procurement plan %1 / %2.', budgetName, planPeriod);
        Header.Status := 'Submitted';
        Header."Submitted On" := CurrentDateTime;
        Header.Modify(true);
        exit(true);
    end;

    local procedure PlanIsSubmitted(budgetName: Code[50]; globalDim1: Code[20]; globalDim2: Code[20]; planPeriod: Code[20]): Boolean
    var
        Header: Record "Portal Procurement Plan Hdr.";
    begin
        Header.SetRange("Budget Name", budgetName);
        Header.SetRange("Plan Period", planPeriod);
        Header.SetRange(Status, 'Submitted');
        exit(not Header.IsEmpty());
    end;

    local procedure ResolvePlanLineDescription(lineType: Integer; typeNo: Code[30]): Text[100]
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
    begin
        case lineType of
            1:
                if GLAccount.Get(typeNo) then
                    exit(CopyStr(GLAccount.Name, 1, 100));
            3:
                if FixedAsset.Get(typeNo) then
                    exit(CopyStr(FixedAsset.Description, 1, 100));
            else
                if Item.Get(typeNo) then
                    exit(CopyStr(Item.Description, 1, 100));
        end;
        exit(typeNo);
    end;

    /// <summary>Accepts the SSP date formats: yyyy-mm-dd (XML) or the BC locale format.</summary>
    local procedure ParsePortalDate(value: Text; var result: Date): Boolean
    begin
        result := 0D;
        value := DelChr(value, '<>', ' ');
        if value = '' then
            exit(false);
        if Evaluate(result, value, 9) then
            exit(true);
        exit(Evaluate(result, value));
    end;
}
