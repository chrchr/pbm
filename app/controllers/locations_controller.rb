class LocationsController < InheritedResources::Base
  respond_to :xml, :json, :html, :js
  has_scope :by_location_name, :by_location_id, :by_machine_id, :by_machine_name, :by_city, :by_zone_id

  def autocomplete
    render :json => Location.find(:all, :conditions => ['name like ?', '%' + params[:term] + '%']).map { |l| l.name }
  end

  def index
    @locations = apply_scopes(Location).where('region_id = ?', @region.id).includes(:location_machine_xrefs, :machines, :location_picture_xrefs)
    @location_data = locations_javascript_data(@locations)
    respond_with(@locations)
  end

  def render_machines
    render :partial => 'locations/render_machines', :locals => {:location => Location.find(params[:id])}
  end

  def render_scores
    render :partial => 'locations/render_scores', :locals => {:lmx => LocationMachineXref.find(params[:id])}
  end

  def unknown_route
    if (params[:page] == 'iphone.html')
      if (params[:init])
        case params[:init].to_i
        when 1 then
          redirect_to "/#{params[:region]}/locations.xml"
        when 2 then
          redirect_to "/#{params[:region]}/regions.xml"
        when 3 then
          redirect_to "/#{params[:region]}/events.xml"
        when 4 then
          redirect_to "/#{params[:region]}/machines.xml"
        end
      elsif (location_id = params[:get_location])
        redirect_to "/#{params[:region]}/locations/#{location_id}.xml"
      elsif (machine_id = params[:get_machine])
        redirect_to "/#{params[:region]}/machines/#{machine_id}.xml"
      elsif (location_id = params[:error])
      elsif (location_id = params[:condition])
      elsif (location_id = params[:modify_location])
      # action? :<
        if (params[:action] == 'add_machine')
        elsif (params[:action] == 'remove_machine')
          LocationMachineXref.find(:all, :conditions => ['location_id = ? and machine_id = ?', location_id, params[:machine_no]]).delete
        end
      end
    end
  end

  def locations_javascript_data(locations)
    ids = Array.new
    lats = Array.new
    lons = Array.new
    contents = Array.new

    locations.each do |l|
      ids      << l.id
      lats     << l.lat
      lons     << l.lon
      contents << l.content_for_infowindow
    end

    [ids, lats, lons, contents]
  end
end
