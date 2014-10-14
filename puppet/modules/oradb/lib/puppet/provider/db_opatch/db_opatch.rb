
Puppet::Type.type(:db_opatch).provide(:db_opatch) do

  def self.instances
    []
  end

  def opatch(action)
    user                    = resource[:os_user]
    patchName               = resource[:name]
    oracle_product_home_dir = resource[:oracle_product_home_dir]
    extracted_patch_dir     = resource[:extracted_patch_dir]
    ocmrf_file              = resource[:ocmrf_file]
    clusterware             = resource[:clusterware]

    Puppet.debug "clusterware result: #{clusterware}"

    unless ocmrf_file.nil?
      ocmrf = ' -ocmrf ' + ocmrf_file
    else
      ocmrf = ''
    end

    if clusterware == false
      if action == :present
        command = "#{oracle_product_home_dir}/OPatch/opatch apply -silent #{ocmrf} -oh #{oracle_product_home_dir} #{extracted_patch_dir}"
      else
        command = "#{oracle_product_home_dir}/OPatch/opatch rollback -id #{patchName} -silent -oh #{oracle_product_home_dir}"
      end
    else
      if action == :present
        command = "#{oracle_product_home_dir}/OPatch/opatch auto #{extracted_patch_dir} #{ocmrf} -oh #{oracle_product_home_dir}"
      else
        command = "#{oracle_product_home_dir}/OPatch/opatch auto -rollback #{extracted_patch_dir} #{ocmrf} -oh #{oracle_product_home_dir}"
      end
    end

    Puppet.debug "opatch action: #{action} with command #{command}"
    if clusterware == true
      output = `su -c '#{command}'`
    else
      output = `su - #{user} -c '#{command}'`
    end
    # output = execute command, :failonfail => true ,:uid => user
    Puppet.info "opatch result: #{output}"

    result = false
    output.each_line do |li|
      unless li.nil?
        if li.include? 'OPatch completed' or li.include? 'OPatch succeeded' or li.include? 'opatch auto succeeded'
          result = true
        end
      end
    end
    fail(output) if result == false
  end

  def opatch_status
    user                    = resource[:os_user]
    patchName               = resource[:name]
    oracle_product_home_dir = resource[:oracle_product_home_dir]
    orainst_dir             = resource[:orainst_dir]
    bundle_sub_patch_id     = resource[:bundle_sub_patch_id]
    clusterware             = resource[:clusterware]

    if clusterware == true
      patchId = bundle_sub_patch_id
    else
      patchId = patchName
    end

    command  = oracle_product_home_dir + '/OPatch/opatch lsinventory -patch_id -oh ' + oracle_product_home_dir + ' -invPtrLoc ' + orainst_dir + '/oraInst.loc'
    Puppet.debug "opatch_status for patch #{patchName} command: #{command}"

    output = `su - #{user} -c '#{command}'`
    # output = execute command, :failonfail => true ,:uid => user
    output.each_line do |li|
      opatch = li[5, li.index(':')-5 ].strip + ';' if (li['Patch'] and li[': applied on'])
      unless opatch.nil?
        Puppet.debug "line #{opatch}"
        if opatch.include? patchId
          Puppet.debug 'found patch'
          return patchId
        end
      end
    end
    'NotFound'
  end

  def present
    opatch :present
  end

  def absent
    opatch :absent
  end

  def status
    output  = opatch_status

    patchName               = resource[:name]
    bundle_sub_patch_id     = resource[:bundle_sub_patch_id]
    clusterware             = resource[:clusterware]

    if clusterware == true
      patchId = bundle_sub_patch_id
    else
      patchId = patchName
    end

    Puppet.debug "opatch_status output #{output} for patchId #{patchId}"
    if output == patchId
      return :present
    else
      return :absent
    end
  end
end
